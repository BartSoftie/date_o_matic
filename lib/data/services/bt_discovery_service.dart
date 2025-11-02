import 'dart:async';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/auto_cleanup_set.dart';
import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

/// This class is responsible for the discovery of other devices nearby that
/// advertise our service.
@injectable
class BtDiscoveryService {
  final _log = Logger('BtState');
  final _centralManager = CentralManager();
  StreamSubscription? _discoverySubscription;
  bool _isListening = false;

  final AutoCleanupSet<UUID> _discoveredDevices =
      AutoCleanupSet(cleanupInterval: Duration(seconds: 30));

  final StreamController<
      bool> _canDiscoverStreamController = StreamController<bool>.broadcast()
    ..add(false); //CentralManager().state == BluetoothLowEnergyState.poweredOn;
  final StreamController<bool> _isListeningStreamController =
      StreamController<bool>.broadcast()..add(false);

  final StreamController<(Peripheral, int)>
      _discoveredPeripheralStreamController =
      StreamController<(Peripheral, int)>.broadcast();

  /// Stops listening and frees all resources.
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
  Stream<bool> get isListeningChanged => _isListeningStreamController.stream;

  /// Returns a stream of discovered peripherals.
  Stream<(Peripheral, int)> get discoveredPeripherals =>
      _discoveredPeripheralStreamController.stream;

  /// Starts listening for nearby devices advertising our service.
  Future startListening() async {
    if (_isListening ||
        !(CentralManager().state == BluetoothLowEnergyState.poweredOn)) {
      _log.shout('... not listening. Already listening or cannot discover.');
      return;
    }

    await _centralManager.startDiscovery();
    _isListeningStreamController.add(true);
    _isListening = true;
    _discoverySubscription = _centralManager.discovered.listen((event) {
      if (event.advertisement.serviceUUIDs
          .contains(BtAdvertisingService.serviceUuid)) {
        if (_discoveredDevices.add(event.peripheral.uuid)) {
          _log.finest(
              'Discovered service: ${event.peripheral.uuid}, RSSI: ${event.rssi}');
          _discoveredPeripheralStreamController
              .add((event.peripheral, event.rssi));
        }
        _log.finest(
            'Discovered known service: ${event.peripheral.uuid}, RSSI: ${event.rssi}');
        _log.finest('Don\'t notifiy');
      }
    });
  }

  /// Stops listening for nearby devices.
  Future stopListening() async {
    _isListening = false;
    _isListeningStreamController.add(false);
    await _centralManager.stopDiscovery();
    _discoverySubscription?.cancel();
  }
}
