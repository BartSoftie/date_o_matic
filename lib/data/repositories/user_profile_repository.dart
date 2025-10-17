import 'dart:async';
import 'dart:collection';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/what_i_want.dart';
import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

/// Repository for user profile related data operations.
@singleton
class UserProfileRepository {
  final _log = Logger('UserProfileRepository');
  final BtDiscoveryService _btDiscoveryService;
  final BtAdvertisingService _btAdvertisingService;
  StreamSubscription? _discoveryStateSubscription;
  StreamSubscription? _advertisingStateSubscription;
  StreamSubscription? _discoverySubscription;
  final StreamController<bool> _isOnlineStreamController =
      StreamController<bool>.broadcast();
  bool _isListening = false;
  bool _isAdvertising = false;

  bool _isConnected = false;

  final HashSet<Peripheral> _connectedPeripherals = HashSet<Peripheral>();
  final List<WhatIWant> _whatTheyWantList = [];

  /// Creates an instance of this class.
  UserProfileRepository({
    required BtDiscoveryService btDiscoveryService,
    required BtAdvertisingService btAdvertisingService,
  })  : _btDiscoveryService = btDiscoveryService,
        _btAdvertisingService = btAdvertisingService {
    _discoveryStateSubscription =
        _btDiscoveryService.isListening.listen((event) {
      if (_isListening != event) {
        bool previous = isOnline;
        _isListening = event;
        if (previous != isOnline) {
          _isOnlineStreamController.add(isOnline);
        }
      }
    });

    _discoverySubscription =
        _btDiscoveryService.discoveredPeripherals.listen((event) async {
      if (_connectedPeripherals.add(event)) {
        final centralManager = CentralManager();
        _log.shout('Connecting to discovered peripheral ${event.uuid}');
        if (_isConnected) {
          _log.shout(
              'Already connected to a peripheral, skipping connection to ${event.uuid}');
          return;
        }

        try {
          await centralManager.connect(event);
          _isConnected = true;

          final services = await centralManager.discoverGATT(event);
          for (var service in services) {
            if (service.uuid == BtAdvertisingService.serviceUuid) {
              _log.shout(
                  'Connected to peripheral ${event.uuid}, discovering characteristics');
              for (var characteristic in service.characteristics) {
                if (characteristic.uuid ==
                    BtAdvertisingService.gattCharacteristicsUuid) {
                  _log.shout(
                      'Reading characteristic from peripheral ${event.uuid}');
                  final data = await centralManager.readCharacteristic(
                      event, characteristic);

                  final whatTheyWant = WhatIWant.fromUint8List(data);
                  _whatTheyWantList.add(whatTheyWant);
                  _log.shout('Value: $whatTheyWant');
                  break;
                }
              }
              break;
            }
          }
        } catch (e) {
          _log.severe(
              'Error while connecting/reading from peripheral ${event.uuid}: $e');
        } finally {
          try {
            await centralManager.disconnect(event);
          } catch (e) {
            _log.severe(
                'Error while disconnecting from peripheral ${event.uuid}: $e');
          } finally {
            _isConnected = false;
          }
        }
        _log.shout('Disconnected from peripheral ${event.uuid}');
      }
    });

    _advertisingStateSubscription =
        _btAdvertisingService.isAdvertisingChanged.listen((event) {
      if (_isAdvertising != event) {
        bool previous = isOnline;
        _isAdvertising = event;
        _isOnlineStreamController.add(isOnline);
        if (previous != isOnline) {
          _isOnlineStreamController.add(isOnline);
        }
      }
    });
  }

  /// Disposes the resources used by this repository.
  //TODO: dispose from ioc
  void dispose() {
    _discoveryStateSubscription?.cancel();
    _advertisingStateSubscription?.cancel();
    _discoverySubscription?.cancel();
    _btAdvertisingService.dispose();
    _btDiscoveryService.dispose();
  }

  /// Returns `true` if the user is currently online (advertising or discovering), else `false`.
  bool get isOnline => _isAdvertising || _isListening;

  /// Returns a stream that emits a value whenever the online status changes.
  Stream<bool> get isOnlineChanged => _isOnlineStreamController.stream;

  /// Returns an unmodifiable list of discovered profiles that match my profile.
  List<WhatIWant> get whatTheyWantList => List.unmodifiable(_whatTheyWantList);

  /// Toggles the online status of the user.
  /// If the user is currently online, they will go offline and vice versa.
  void toggleOnlineStatus() {
    if (isOnline) {
      _btAdvertisingService.stopAdvertising();
      _btDiscoveryService.stopListening();
    } else {
      _btDiscoveryService.startListening();
      _btAdvertisingService.startAdvertising();
    }
  }
}
