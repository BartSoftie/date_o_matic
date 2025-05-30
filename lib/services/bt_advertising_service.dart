import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/gender.dart';
import 'package:date_o_matic/data/relationship_type.dart';
import 'package:date_o_matic/data/what_i_want.dart';
import 'package:flutter/material.dart';

/// This service is responsible for the process of advertising our BLE service.
class BtAdvertisingService {
  bool _advertising = false;

  /// The unique identifier of our advertising service.
  static final serviceUuid =
      UUID.fromString('5b92b99a-05ab-4c89-8c73-31edfb506213');

  /// The unique identifier of our GATT characteristics.
  static final gattCharacteristicsUuid =
      UUID.fromString('039c5faf-c609-46af-9a67-ce4e68c872d5');

  /// Returns `true` if the service is currently advertising, else `false`.
  bool get advertising => _advertising;

  /// Disposes this instance, stops advertising and frees all resources.
  void dispose() {
    stopAdvertising();
  }

  /// Starts advertising our dating service and tells listeners that we are here.
  void startAdvertising() async {
    final peripheralManager = PeripheralManager();
    final state = peripheralManager.state;
    await peripheralManager.removeAllServices();
    if (state != BluetoothLowEnergyState.poweredOn) {
      debugPrint('Bluetooth not powered on');
      //TODO: report error
      return;
    }
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
    peripheralManager.addService(hereIAmService);
    final advertisement = Advertisement(
      serviceUUIDs: [serviceUuid],
      // name: 'Pixel 5',
      // manufacturerSpecificData: ManufacturerSpecificData(
      //   id: 0x1234, //TODO: we need our own company id here
      //   data: Uint8List.fromList('SomeData'.codeUnits),
      // ),
    );
    try {
      await peripheralManager.startAdvertising(advertisement);
      _advertising = true;
    } catch (e) {
      debugPrint('startAdvertising failed: $e');
    }
  }

  /// Stops advertising so others won't see us anymore.
  Future<void> stopAdvertising() async {
    final peripheralManager = PeripheralManager();
    try {
      await peripheralManager.stopAdvertising();
      await peripheralManager.removeAllServices();
      _advertising = false;
    } catch (e) {
      debugPrint('stopAdvertising failed: $e');
    }
  }
}
