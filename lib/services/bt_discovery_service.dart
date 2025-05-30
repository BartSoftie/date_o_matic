import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/what_i_want.dart';
import 'package:date_o_matic/services/bt_advertising_service.dart';
import 'package:flutter/material.dart';

/// This class is responsible for the discovery of other devices nearby that
/// advertise our service.
class BtDiscoveryService {
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
        debugPrint('gotcha');
        if (_connectedTo != event.peripheral.uuid) {
          _connectedTo = event.peripheral.uuid;
          await centralManager.connect(event.peripheral);
          debugPrint('Connected');
          var gatt = await centralManager.discoverGATT(event.peripheral);
          if (gatt.isNotEmpty) {
            debugPrint('not empty');
            var value = await centralManager.readCharacteristic(
                event.peripheral, gatt[2].characteristics[0]);

            debugPrint('Got Charachteristics: $value');
            var whatHeWants = WhatIWant.fromUint8List(value);
            debugPrint('Value: $whatHeWants');
          }

          // then((value) {
          //   debugPrint('Connected');
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
          //     debugPrint('$value');
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
