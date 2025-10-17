import 'dart:async';

import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:injectable/injectable.dart';

/// Repository for user profile related data operations.
@singleton
class UserProfileRepository {
  final BtDiscoveryService _btDiscoveryService;
  final BtAdvertisingService _btAdvertisingService;
  StreamSubscription? _discoverySubscription;
  StreamSubscription? _advertisingSubscription;
  final StreamController<bool> _isOnlineStreamController =
      StreamController<bool>.broadcast();
  bool _isListening = false;
  bool _isAdvertising = false;

  /// Creates an instance of this class.
  UserProfileRepository({
    required BtDiscoveryService btDiscoveryService,
    required BtAdvertisingService btAdvertisingService,
  })  : _btDiscoveryService = btDiscoveryService,
        _btAdvertisingService = btAdvertisingService {
    _discoverySubscription = _btDiscoveryService.isListening.listen((event) {
      if (_isListening != event) {
        bool previous = isOnline;
        _isListening = event;
        if (previous != isOnline) {
          _isOnlineStreamController.add(isOnline);
        }
      }
    });

    _advertisingSubscription =
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
    _discoverySubscription?.cancel();
    _advertisingSubscription?.cancel();
    _btAdvertisingService.dispose();
    _btDiscoveryService.dispose();
  }

  /// Returns `true` if the user is currently online (advertising or discovering), else `false`.
  bool get isOnline => _isAdvertising || _isListening;

  /// Returns a stream that emits a value whenever the online status changes.
  Stream<bool> get isOnlineChanged => _isOnlineStreamController.stream;

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
