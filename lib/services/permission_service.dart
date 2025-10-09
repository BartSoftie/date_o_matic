import 'package:permission_handler/permission_handler.dart';

/// A service to handle permissions.
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  Map<Permission, PermissionStatus> _statuses = {};

  /// Returns the singleton instance of [PermissionService].
  factory PermissionService.instance() => _instance;
  PermissionService._internal();

  /// Returns true if all required permissions are granted.
  bool get allGranted =>
      bluetoothScanStatus.isGranted &&
      bluetoothConnectStatus.isGranted &&
      bluetoothAdvertiseStatus.isGranted;

  /// Returns the status of the Bluetooth Scan permission.
  PermissionStatus get bluetoothScanStatus =>
      _statuses[Permission.bluetoothScan] ?? PermissionStatus.denied;

  /// Returns the status of the Bluetooth Connect permission.
  PermissionStatus get bluetoothConnectStatus =>
      _statuses[Permission.bluetoothConnect] ?? PermissionStatus.denied;

  /// Returns the status of the Bluetooth Advertise permission.
  PermissionStatus get bluetoothAdvertiseStatus =>
      _statuses[Permission.bluetoothAdvertise] ?? PermissionStatus.denied;

  /// Requests the necessary permissions.
  Future request() async {
    //TODO: check if iOS needs other permissions
    //await Permission.bluetooth.request();
    _statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();
  }
}
