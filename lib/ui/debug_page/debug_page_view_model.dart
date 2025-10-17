import 'dart:async';

import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// ViewModel for the [LogPage]
class DebugPageViewModel extends ChangeNotifier {
  String _logText = '';
  late final StreamSubscription _streamSubscription;
  //TODO: pass them as parameters
  final _advertisingService = BtAdvertisingService();
  final _discoveryService = BtDiscoveryService();

  /// Creates an instance of this class
  DebugPageViewModel() {
    _streamSubscription = Logger.root.onRecord.listen((record) {
      _logText += '${record.level.name}: ${record.time}: ${record.message}\n';
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  /// gets the log text that is shown in the UI
  String get logText => _logText;

  /// Starts advertising our service
  void startAdvertising() {
    _advertisingService.startAdvertising();
  }

  /// Stops advertising our service
  void stopAdvertising() {
    _advertisingService.stopAdvertising();
  }

  /// Starts discovering other devices advertising our service
  void startDiscovery() {
    _discoveryService.startListening();
  }

  /// Stops discovering other devices advertising our service
  void stopDiscovery() {
    _discoveryService.stopListening();
  }
}
