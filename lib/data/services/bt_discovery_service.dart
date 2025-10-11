import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/what_i_want.dart';
import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:logging/logging.dart';

/// This class is responsible for the discovery of other devices nearby that
/// advertise our service.
class BtDiscoveryService {
  final _log = Logger('BtState');
  UUID? _connectedTo;
  StreamSubscription? _subscription;
  bool _listening = false;

  /// Returns `true` if we are allowed to discover, else `false`.
  bool get canDiscover =>
      CentralManager().state == BluetoothLowEnergyState.poweredOn;

  /// Stops listening and frees all resources.
  void dispose() {
    stopListening();
  }

  /// Starts listening for nearby devices advertising our service.
  void startListening() async {
    if (_listening || !canDiscover) {
      _log.shout('... not listening. Already listening or cannot discover.');
      return;
    }

    final centralManager = CentralManager();
    centralManager.startDiscovery();
    _listening = true;
    _subscription = centralManager.discovered.listen((event) async {
      if (event.advertisement.serviceUUIDs
          .contains(BtAdvertisingService.serviceUuid)) {
        //TODO: connect, store data with peripheral uuid as key and disconnect again
        //if (_connectedTo == null) {
        //event.peripheral.uuid) {
        //_connectedTo = event.peripheral.uuid;
        _log.shout('Discovered service');
        // adding service data currently leads to crash on android
        // advertising not possible. maybe in the future.
        // var wiwVal =
        //     event.advertisement.serviceData[BtAdvertisingService.serviceUuid];
        // _log.shout('Got ServiceData: $wiwVal');
        // if (wiwVal != null) {
        //   var wivV = WhatIWant.fromUint8List(wiwVal);
        //   _log.shout('ServiceData value: $wivV');
        // }
        //TODO: multiple connections should work
        await centralManager.connect(event.peripheral);
        _log.shout('Connected');
        var gatt = await centralManager.discoverGATT(event.peripheral);
        if (gatt.isNotEmpty) {
          _log.shout('not empty');
          //TODO: can I filter for g.uuid? make this more robust. provide orElse to firstWhere
          var service = gatt
              .firstWhere((g) => g.uuid == BtAdvertisingService.serviceUuid);
          var characteristics = service.characteristics.firstWhere(
              (c) => c.uuid == BtAdvertisingService.gattCharacteristicsUuid);
          var value = await centralManager.readCharacteristic(
              event.peripheral, characteristics);

          _log.shout('Got Charachteristics: $value');
          var whatHeWants = WhatIWant.fromUint8List(value);
          _log.shout('Value: $whatHeWants');
        }
        await centralManager.disconnect(event.peripheral);
        _log.shout('Disconnected');

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
  void stopListening() async {
    final centralManager = CentralManager();
    _listening = false;
    centralManager.stopDiscovery();
    _subscription?.cancel();
    _connectedTo = null;
  }
}
