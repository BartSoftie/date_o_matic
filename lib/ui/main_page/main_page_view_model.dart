import 'dart:async';

import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// ViewModel for the [MainPage]
class MainPageViewModel extends ChangeNotifier {
  final _log = Logger('BtState');
  late StreamSubscription _streamSubscription;
  final _advertisingService = BtAdvertisingService();
  final _discoveryService = BtDiscoveryService();
  String _logText = '';

  /// Gets the log text that is shown in the UI
  MainPageViewModel() {
    Logger.root.level = Level.WARNING;
    _streamSubscription = _log.onRecord.listen((record) {
      _logText += '${record.level.name}: ${record.time}: ${record.message}\n';
      notifyListeners();
    });
  }
  //   @override
  // void dispose() {
  //   _advertisingService.dispose();
  //   _discoveryService.dispose();
  //   _streamSubscription.cancel();
  //   super.dispose();
  // }

  String get logText => _logText;

  void startAdvertising() {
    _advertisingService.startAdvertising();
  }

  void stopAdvertising() {
    _advertisingService.stopAdvertising();
  }

  void startDiscovery() {
    _discoveryService.startListening();
  }

  void stopDiscovery() {
    _discoveryService.stopListening();
  }
}
