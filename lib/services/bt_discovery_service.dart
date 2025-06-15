import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/what_i_want.dart';
import 'package:date_o_matic/services/bt_advertising_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// This class is responsible for the discovery of other devices nearby that
/// advertise our service.
class BtDiscoveryService {
  final _log = Logger('BtState');
  UUID? _connectedTo;
  StreamSubscription? _subscription;
  void dispose() {
    stopListening();
  }

  void startListening() async {
    final centralManager = CentralManager();
    centralManager.startDiscovery();
    _subscription = centralManager.discovered.listen((event) async {
      if (event.advertisement.serviceUUIDs
          .contains(BtAdvertisingService.serviceUuid)) {
        if (_connectedTo != event.peripheral.uuid) {
          _connectedTo = event.peripheral.uuid;
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
        }
      }
    });
  }

  void stopListening() async {
    final centralManager = CentralManager();
    centralManager.stopDiscovery();
    _subscription?.cancel();
    _connectedTo = null;
  }
}
