import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// ViewModel for the [MainPage]
class MainPageViewModel extends ChangeNotifier {
  //final _log = Logger('BtState');
  //TODO: pass them as parameters
  final _advertisingService = BtAdvertisingService();
  final _discoveryService = BtDiscoveryService();

  /// Creates an instance of this class
  MainPageViewModel() {
    //TODO: set the root log level somewhwere else
    Logger.root.level = Level.WARNING;
  }

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
