import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/gender.dart';
import 'package:date_o_matic/data/relationship_type.dart';
import 'package:date_o_matic/data/what_i_want.dart';
import 'package:logging/logging.dart';

/// This service is responsible for the process of advertising our BLE service.
class BtAdvertisingService {
  final _log = Logger('BtState');
  final _peripheralManager = PeripheralManager();
  bool _advertising = false;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _characteristicReadRequestedSubscription;
  late final StreamSubscription _characteristicWriteRequestedSubscription;
  late final StreamSubscription _characteristicNotifyStateChangedSubscription;

  /// The unique identifier of our advertising service.
  static final serviceUuid =
      UUID.fromString('5b92b99a-05ab-4c89-8c73-31edfb506213');

  /// The unique identifier of our GATT characteristics.
  static final gattCharacteristicsUuid =
      UUID.fromString('039c5faf-c609-46af-9a67-ce4e68c872d5');

  BtAdvertisingService() {
    _stateChangedSubscription =
        _peripheralManager.stateChanged.listen((eventArgs) async {
      if (eventArgs.state == BluetoothLowEnergyState.unauthorized &&
          Platform.isAndroid) {
        await _peripheralManager.authorize();
      }
      //notifyListeners();
    });
    _characteristicReadRequestedSubscription = _peripheralManager
        .characteristicReadRequested
        .listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final request = eventArgs.request;
      final offset = request.offset;
      _log.info(
          'Characteristic read requested: ${central.uuid}, ${characteristic.uuid}, $offset');
      //notifyListeners();
      final elements = List.generate(100, (i) => i % 256);
      final value = Uint8List.fromList(elements);
      final trimmedValue = value.sublist(offset);
      await _peripheralManager.respondReadRequestWithValue(
        request,
        value: trimmedValue,
      );
    });
    _characteristicWriteRequestedSubscription = _peripheralManager
        .characteristicWriteRequested
        .listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final request = eventArgs.request;
      final offset = request.offset;
      final value = request.value;
      _log.info(
          'Characteristic write requested: [${value.length}] ${central.uuid}, ${characteristic.uuid}, $offset, $value');
      //notifyListeners();
      await _peripheralManager.respondWriteRequest(request);
    });
    _characteristicNotifyStateChangedSubscription = _peripheralManager
        .characteristicNotifyStateChanged
        .listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final state = eventArgs.state;
      _log.info(
          'Characteristic notify state changed: ${central.uuid}, ${characteristic.uuid}, $state');
      //notifyListeners();
      // Write someting to the central when notify started.
      if (state) {
        final maximumNotifyLength =
            await _peripheralManager.getMaximumNotifyLength(central);
        final elements = List.generate(maximumNotifyLength, (i) => i % 256);
        final value = Uint8List.fromList(elements);
        await _peripheralManager.notifyCharacteristic(
          central,
          characteristic,
          value: value,
        );
      }
    });
  }

  /// Returns `true` if the service is currently advertising, else `false`.
  bool get advertising => _advertising;

  /// Disposes this instance, stops advertising and frees all resources.
  void dispose() {
    stopAdvertising();

    _stateChangedSubscription.cancel();
    _characteristicReadRequestedSubscription.cancel();
    _characteristicWriteRequestedSubscription.cancel();
    _characteristicNotifyStateChangedSubscription.cancel();
  }

  /// Starts advertising our dating service and tells listeners that we are here.
  void startAdvertising() async {
    if (_advertising) {
      return;
    }

    _log.shout('Bluetooth powered on. Removing services...');
    await _peripheralManager.removeAllServices();

    // final state = _peripheralManager.state;
    // if (state != BluetoothLowEnergyState.poweredOn) {
    //   _log.shout('Bluetooth not powered on. Curent state $state');
    //   //TODO: report error
    //   return;
    // }
    _log.shout('  ...done');
    final myDob = DateTime(1973, 5, 28);
    final whatIWant = WhatIWant(
      gender: Gender.female,
      relationshipType: RelationshipType.friendsWithBenefits,
      bornFrom: myDob.copyWith(year: myDob.year - 10),
      bornTill: myDob.copyWith(year: myDob.year + 10),
    );
    final hereIAmService = GATTService(
      uuid: serviceUuid,
      isPrimary: true, //???
      includedServices: [], //???
      characteristics: [
        GATTCharacteristic.immutable(
          uuid: gattCharacteristicsUuid, //UUID.short(200),
          value: whatIWant.asUint8List(),
          descriptors: [
            // GATTDescriptor.immutable(
            //     uuid: immutableDescriptorUUID,
            //     value: immutableDescriptorValue,
            // ),
          ],
        ),
      ],
    );
    _peripheralManager.addService(hereIAmService);
    final advertisement = Advertisement(
      serviceUUIDs: [serviceUuid],
      //serviceData: {serviceUuid: whatIWant.asUint8List()},
      // name: 'Pixel 5',
      // manufacturerSpecificData: ManufacturerSpecificData(
      //   id: 0x1234, //TODO: we need our own company id here
      //   data: Uint8List.fromList('SomeData'.codeUnits),
      // ),
    );
    try {
      await _peripheralManager.startAdvertising(advertisement);
      _advertising = true;
      _log.shout('Advertising now...');
    } catch (e) {
      _log.shout('startAdvertising failed: $e');
    }
  }

  /// Stops advertising so others won't see us anymore.
  Future<void> stopAdvertising() async {
    _log.shout('stopAdvertising...');
    if (!_advertising) {
      _log.shout('... not advertising. nothing to do.');
      return;
    }

    final peripheralManager = PeripheralManager();
    try {
      await peripheralManager.stopAdvertising();
      _log.shout('Advertising stopped');
      _advertising = false;
    } catch (e) {
      _log.shout('stopAdvertising failed: $e');
    }
  }
}
