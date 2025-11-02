import 'dart:convert';

import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/search_profile.dart';
import 'package:date_o_matic/data/model/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

/// Service for securely storing data using Hive with encryption.
@singleton
class HiveSecureService {
  static const String _encryptionKeyName = 'hive_encryption_key';
  static const String _whatIWantBoxName = 'whatIWantBox';
  static const String _personalProfileBoxName = 'whoIAmBox';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late Box<SearchProfile> _searchProfilesBox;
  late Box<UserProfile> _personalProfileBox;
  static const String _myProfileKey = 'myProfileKey';

  /// Initializes the Hive secure service by setting up Hive and opening the encrypted box.
  Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(SearchProfileAdapter());
    Hive.registerAdapter(GenderAdapter());
    Hive.registerAdapter(RelationshipTypeAdapter());

    final encryptionKey = await _getOrCreateEncryptionKey();
    _searchProfilesBox = await Hive.openBox<SearchProfile>(
      _whatIWantBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _personalProfileBox = await Hive.openBox<UserProfile>(
      _personalProfileBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  /// Disposes the Hive boxes.
  void dispose() {
    _searchProfilesBox.close();
    _personalProfileBox.close();
  }

  /// Loads the user profile from the secure Hive box.
  UserProfile? loadUserProfile() {
    return _personalProfileBox.get(_myProfileKey);
  }

  /// Saves the user profile to the secure Hive box.
  Future<void> saveUserProfile(UserProfile settings) async {
    await _personalProfileBox.put(_myProfileKey, settings);
  }

  /// Adds a new search profile to the secure Hive box.
  Future<void> addSearchProfile(SearchProfile newProfile) async {
    int index = await _searchProfilesBox.add(newProfile);
    newProfile.profileId = index;
    await _searchProfilesBox.put(index, newProfile);
  }

  /// Updates an existing search profile in the secure Hive box.
  Future<void> updateSearchProfile(SearchProfile changedProfile) async {
    await _searchProfilesBox.put(changedProfile.profileId, changedProfile);
  }

  /// Retrieves all search profiles from the secure Hive box.
  List<SearchProfile> get searchProfiles => _searchProfilesBox.values.toList();

  /// Removes the search profile with the given [profileId] from the
  /// secure Hive box.
  Future<void> removeSearchProfile(int profileId) async {
    await _searchProfilesBox.delete(profileId);
  }

  Future<Uint8List> _getOrCreateEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _encryptionKeyName);

    if (keyString == null) {
      final keyList = Hive.generateSecureKey();
      final key = Uint8List.fromList(keyList);

      keyString = base64Encode(key);
      await _secureStorage.write(key: _encryptionKeyName, value: keyString);

      return key;
    } else {
      return base64Decode(keyString);
    }
  }
}
