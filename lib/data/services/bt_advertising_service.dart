import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/search_profile.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

/// This service is responsible for the process of advertising our BLE service.
@injectable
class BtAdvertisingService {
  final _log = Logger('BtState');
  final _peripheralManager = PeripheralManager();
  bool _isAdvertising = false;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _characteristicReadRequestedSubscription;
  late final StreamSubscription _characteristicWriteRequestedSubscription;
  late final StreamSubscription _characteristicNotifyStateChangedSubscription;

  final StreamController<
      bool> _canAdvertiseStreamController = StreamController<bool>.broadcast()
    ..add(false); //CentralManager().state == BluetoothLowEnergyState.poweredOn;
  final StreamController<bool> _isAdvertisingStreamController =
      StreamController<bool>.broadcast()..add(false);

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
        _canAdvertiseStreamController.add(false);
        await _peripheralManager.authorize();
      } else if (eventArgs.state == BluetoothLowEnergyState.poweredOn) {
        _canAdvertiseStreamController.add(true);
      } else if (eventArgs.state == BluetoothLowEnergyState.poweredOff ||
          eventArgs.state == BluetoothLowEnergyState.unsupported) {
        _canAdvertiseStreamController.add(false);
        //somehow we get unsupported on android if bt is powered off
      }
    });
  }

  /// Stops listening and frees all resources.
  void dispose() {
    stopAdvertising().then((value) {
      _canAdvertiseStreamController.close();
      _isAdvertisingStreamController.close();
      _stateChangedSubscription.cancel();
      _characteristicReadRequestedSubscription.cancel();
      _characteristicWriteRequestedSubscription.cancel();
      _characteristicNotifyStateChangedSubscription.cancel();
    });
  }

  /// Returns `true` if we are allowed to advertise, else `false`.
  bool get canAdvertise =>
      _peripheralManager.state == BluetoothLowEnergyState.poweredOn;

  /// Returns a stream that notifies about changes to the ability to advertise.
  Stream<bool> get canAdvertiseChanged => _canAdvertiseStreamController.stream;

  /// Returns `true` if the service is currently advertising, else `false`.
  bool get isAdvertising => _isAdvertising;

  /// Returns a stream that notifies about changes to the advertising status.
  Stream<bool> get isAdvertisingChanged =>
      _isAdvertisingStreamController.stream;

  /// Starts advertising our dating service and tells listeners that we are here.
  Future startAdvertising(SearchProfile whatIWant) async {
    if (_isAdvertising || !canAdvertise) {
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
      _isAdvertising = true;
      _isAdvertisingStreamController.add(true);
      _log.shout('Advertising now...');
    } catch (e) {
      _log.shout('startAdvertising failed: $e');
    }
  }

  /// Stops advertising so others won't see us anymore.
  Future<void> stopAdvertising() async {
    _log.shout('stopAdvertising...');
    if (!_isAdvertising) {
      _log.shout('... not advertising. nothing to do.');
      return;
    }

    final peripheralManager = PeripheralManager();
    try {
      await peripheralManager.stopAdvertising();
      _log.shout('Advertising stopped');
      _isAdvertising = false;
      _isAdvertisingStreamController.add(false);
    } catch (e) {
      _log.shout('stopAdvertising failed: $e');
    }
  }
}
