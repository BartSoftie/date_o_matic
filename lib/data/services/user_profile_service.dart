import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Service to generate and provide a unique user ID based on device information.
@singleton
class UserProfileService {
  /// Generates a unique user ID based on device-specific information.
  Future<int> generateUserId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String persistentId;

    if (defaultTargetPlatform == TargetPlatform.android) {
      // ID des Android-Geräts (am stabilsten auf Android)
      final androidInfo = await deviceInfo.androidInfo;
      persistentId = androidInfo.id;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // IDFV auf iOS (ändert sich nur bei Deinstallation ALLER Apps des Entwicklers)
      final iosInfo = await deviceInfo.iosInfo;
      persistentId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
    } else {
      // Fallback für andere Plattformen
      persistentId = 'fallback_device_id';
    }

    // Konvertiere den persistenten String-Bezeichner in einen Integer-Hash
    return _stringTo64BitHash(persistentId);
  }

  static int _stringTo64BitHash(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = 0x1ffffffff & (hash + input.codeUnitAt(i)); // Addition
      hash = 0x1ffffffff & (hash + ((0x0007ffff & hash) << 10)); // Verschiebung
      hash ^= hash >> 6; // XOR
    }

    return hash.toSigned(63);
  }
}
