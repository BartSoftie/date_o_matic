import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

/// This class is responsible for the discovery of other devices nearby that
/// advertise our service.
@injectable
class BtDiscoveryService {
  final _log = Logger('BtState');
  StreamSubscription? _discoverySubscription;
  bool _isListening = false;

  final StreamController<
      bool> _canDiscoverStreamController = StreamController<bool>.broadcast()
    ..add(false); //CentralManager().state == BluetoothLowEnergyState.poweredOn;
  final StreamController<bool> _isListeningStreamController =
      StreamController<bool>.broadcast()..add(false);

  final StreamController<Peripheral> _discoveredPeripheralStreamController =
      StreamController<Peripheral>.broadcast();

  /// Stops listening and frees all resources.
  //TODO: dispose from ioc
  void dispose() {
    stopListening().then((value) {
      _canDiscoverStreamController.close();
      _isListeningStreamController.close();
      _discoverySubscription?.cancel();
    });
  }

  /// Returns `true` if the device can discover other devices, else `false`.
  Stream<bool> get canDiscover => _canDiscoverStreamController.stream;
  //CentralManager().state == BluetoothLowEnergyState.poweredOn;

  /// Returns `true` if we are currently listening for nearby devices, else `false`.
  Stream<bool> get isListening => _isListeningStreamController.stream;

  /// Returns a stream of discovered peripherals.
  Stream<Peripheral> get discoveredPeripherals =>
      _discoveredPeripheralStreamController.stream;

  /// Starts listening for nearby devices advertising our service.
  void startListening() async {
    if (_isListening ||
        !(CentralManager().state == BluetoothLowEnergyState.poweredOn)) {
      _log.shout('... not listening. Already listening or cannot discover.');
      return;
    }

    final centralManager = CentralManager();
    centralManager.startDiscovery();
    _isListeningStreamController.add(true);
    _isListening = true;
    _discoverySubscription = centralManager.discovered.listen((event) async {
      if (event.advertisement.serviceUUIDs
          .contains(BtAdvertisingService.serviceUuid)) {
        //TODO: connect, store data with peripheral uuid as key and disconnect again
        //if (_connectedTo == null) {
        //event.peripheral.uuid) {
        //_connectedTo = event.peripheral.uuid;
        _log.finest(
            'Discovered service: ${event.peripheral.uuid}, RSSI: ${event.rssi}');
        _discoveredPeripheralStreamController.add(event.peripheral);
        // adding service data currently leads to crash on android
        // advertising not possible. maybe in the future.
        // var wiwVal =
        //     event.advertisement.serviceData[BtAdvertisingService.serviceUuid];
        // _log.shout('Got ServiceData: $wiwVal');
        // if (wiwVal != null) {
        //   var wivV = WhatIWant.fromUint8List(wiwVal);
        //   _log.shout('ServiceData value: $wivV');
        // }
        // //TODO: multiple connections should work
        // await centralManager.connect(event.peripheral);
        // _log.shout('Connected');
        // var gatt = await centralManager.discoverGATT(event.peripheral);
        // if (gatt.isNotEmpty) {
        //   _log.shout('not empty');
        //   //TODO: can I filter for g.uuid? make this more robust. provide orElse to firstWhere
        //   var service = gatt
        //       .firstWhere((g) => g.uuid == BtAdvertisingService.serviceUuid);
        //   var characteristics = service.characteristics.firstWhere(
        //       (c) => c.uuid == BtAdvertisingService.gattCharacteristicsUuid);
        //   var value = await centralManager.readCharacteristic(
        //       event.peripheral, characteristics);

        //   _log.shout('Got Charachteristics: $value');
        //   var whatHeWants = WhatIWant.fromUint8List(value);
        //   _log.shout('Value: $whatHeWants');
        // }
        // await centralManager.disconnect(event.peripheral);
        //_log.shout('Disconnected');

        // then((value) {
        //   _log.shout('Connected');
        //   CentralManager.instance
        //       .readCharacteristic(
        //     GattCharacteristic(
        //       uuid: BtAdvertisingService.gattCharacteristicsUuid,
        //       properties: [],
        //       //value: whatIWant.asUint8List(),
        //       descriptors: [/*GattDescriptor(uuid: UUID.short(201))*/],
        //     ),
        //   )
        //       .then((value) {
        //     _log.shout('$value');
        //   });
        // });
        //}
      }
    });
  }

  /// Stops listening for nearby devices.
  Future stopListening() async {
    final centralManager = CentralManager();
    _isListening = false;
    _isListeningStreamController.add(false);
    await centralManager.stopDiscovery();
    _discoverySubscription?.cancel();
  }
}
