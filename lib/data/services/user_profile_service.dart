import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Service to generate and provide a unique user ID based on device information.
@injectable
class UserProfileService {
  /// Generates a unique user ID based on device-specific information.
  Future<int> generateUserId() async {
    //TODO: find a way to take the id to another device if the user changes device but wants to keep his profile
    //maybe just generate once and store it securely (what if the user uninstalls the app?)
    //or, if we keep firebase integration, use firebase auth uid
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String persistentId;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      persistentId = androidInfo.id;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      persistentId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
    } else {
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
