import 'dart:async';
import 'dart:io';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/what_i_want.dart';
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

  /// Creates an instance of [BtAdvertisingService] and starts listening to
  /// bluetooth peripheral state changes.
  BtAdvertisingService() {
    _stateChangedSubscription =
        _peripheralManager.stateChanged.listen((eventArgs) async {
      //TODO: handle states correctly
      if (eventArgs.state == BluetoothLowEnergyState.unauthorized &&
          Platform.isAndroid) {
        await _peripheralManager.authorize();
      } else if (eventArgs.state == BluetoothLowEnergyState.poweredOn) {
      } else if (eventArgs.state == BluetoothLowEnergyState.poweredOff ||
          eventArgs.state == BluetoothLowEnergyState.unsupported) {
        //somehow we get unsupported on android if bt is powered off
      }
    });
  }

  /// Returns `true` if we are allowed to advertise, else `false`.
  bool get canAdvertise =>
      _peripheralManager.state == BluetoothLowEnergyState.poweredOn;

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
    if (_advertising || !canAdvertise) {
      _log.shout(
          '... not advertising. Already advertising or cannot advertise.');
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
