import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/matched_profile.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/search_profile.dart';
import 'package:date_o_matic/data/model/user_profile.dart';
import 'package:date_o_matic/data/services/bt_advertising_service.dart';
import 'package:date_o_matic/data/services/bt_discovery_service.dart';
import 'package:date_o_matic/data/services/hive_secure_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

/// Repository for user profile related data operations.
@singleton
class UserProfileRepository {
  final _log = Logger('UserProfileRepository');
  final BtDiscoveryService _btDiscoveryService;
  final BtAdvertisingService _btAdvertisingService;
  final HiveSecureService _hiveSecureService;
  // StreamSubscription? _discoveryStateSubscription;
  // StreamSubscription? _advertisingStateSubscription;
  // StreamSubscription? _discoverySubscription;
  final StreamController<bool> _isOnlineStreamController =
      StreamController<bool>.broadcast();
  final StreamController<MatchedProfile> _profileDiscoveredController =
      StreamController<MatchedProfile>.broadcast();

  final _searchProfile = SearchProfile(
    profileId: Random().nextInt(1 << 32),
    userId: Random().nextInt(1 << 32),
    name: 'Default Profile',
    gender: Gender.female,
    relationshipType: RelationshipType.friendsWithBenefits,
    bornFrom:
        DateTime(1973, 5, 28).copyWith(year: DateTime(1973, 5, 28).year - 10),
    bornTill:
        DateTime(1973, 5, 28).copyWith(year: DateTime(1973, 5, 28).year + 10),
  );

  bool _isListening = false;
  bool _isAdvertising = false;
  bool _isConnected = false;

  final HashSet<int> _noMatchList = HashSet<int>();
  final Map<int, MatchedProfile> _matchList = {};

  /// Creates an instance of this class.
  UserProfileRepository({
    required BtDiscoveryService btDiscoveryService,
    required BtAdvertisingService btAdvertisingService,
    required HiveSecureService hiveSecureService,
  })  : _btDiscoveryService = btDiscoveryService,
        _btAdvertisingService = btAdvertisingService,
        _hiveSecureService = hiveSecureService {
    //_discoveryStateSubscription =
    _btDiscoveryService.isListeningChanged.listen(_onDiscoveryStateChanged);

    //_discoverySubscription =
    _btDiscoveryService.discoveredPeripherals.listen(_onDeviceDiscovered);

    //_advertisingStateSubscription =
    _btAdvertisingService.isAdvertisingChanged
        .listen(_onAdvertisingStateChanged);
  }

  // As long as this class is a singleton, we do not need to dispose it.
  // /// Disposes the resources used by this repository.
  // @disposeMethod
  // void dispose() {
  //   _hiveSecureService.dispose();
  //   _isOnlineStreamController.close();
  //   _profileDiscoveredController.close();
  //   _discoveryStateSubscription?.cancel();
  //   _advertisingStateSubscription?.cancel();
  //   _discoverySubscription?.cancel();
  //   _btAdvertisingService.dispose();
  //   _btDiscoveryService.dispose();
  // }

  /// Returns `true` if the user is currently online (advertising or discovering), else `false`.
  bool get isOnline => _isAdvertising || _isListening;

  /// Returns a stream that emits a value whenever the online status changes.
  Stream<bool> get isOnlineChanged => _isOnlineStreamController.stream;

  /// Gets or sets the user's profile.
  UserProfile? get userProfile => _hiveSecureService.loadUserProfile();
  set userProfile(UserProfile? profile) {
    if (profile != null) {
      _hiveSecureService.saveUserProfile(profile);
    }
  }

  /// Returns an unmodifiable list of discovered profiles that match my profile.
  List<MatchedProfile> get matchedProfilesList =>
      List.unmodifiable(_matchList.values);

  /// Returns a stream that emits a [SearchProfile] object whenever a new profile is discovered.
  Stream<MatchedProfile> get profileDiscovered =>
      _profileDiscoveredController.stream;

  /// Toggles the online status of the user.
  /// If the user is currently online, they will go offline and vice versa.
  Future toggleOnlineStatus() async {
    if (isOnline) {
      await _btAdvertisingService.stopAdvertising();
      await _btDiscoveryService.stopListening();
    } else {
      await _btDiscoveryService.startListening();
      await _btAdvertisingService.startAdvertising(_searchProfile);
    }
  }

  void _onDiscoveryStateChanged(bool event) {
    if (_isListening != event) {
      bool previous = isOnline;
      _isListening = event;
      if (previous != isOnline) {
        _isOnlineStreamController.add(isOnline);
      }
    }
  }

  void _onAdvertisingStateChanged(bool event) {
    if (_isAdvertising != event) {
      bool previous = isOnline;
      _isAdvertising = event;
      _isOnlineStreamController.add(isOnline);
      if (previous != isOnline) {
        _isOnlineStreamController.add(isOnline);
      }
    }
  }

  void _onDeviceDiscovered((Peripheral, int) event) async {
    SearchProfile? whatTheyWant = await _getTheirSearchProfile(event.$1);
    if (whatTheyWant != null) {
      if (_noMatchList.contains(whatTheyWant.userId)) {
        return;
      }

      if (_matchList.containsKey(whatTheyWant.userId) || _match(whatTheyWant)) {
        MatchedProfile profile = MatchedProfile(
            profile: whatTheyWant,
            matchScore: 100,
            lastSeen: DateTime.now(),
            rssi: event.$2);
        _matchList[whatTheyWant.userId] = profile;
        _profileDiscoveredController.add(profile);
        return;
      }

      _noMatchList.add(whatTheyWant.userId);
    }
  }

  Future<SearchProfile?> _getTheirSearchProfile(Peripheral event) async {
    SearchProfile? whatTheyWant;
    final centralManager = CentralManager();
    _log.shout('Connecting to discovered peripheral ${event.uuid}');
    if (_isConnected) {
      _log.shout(
          'Already connected to a peripheral, skipping connection to ${event.uuid}');
      return null;
    }

    try {
      await _btDiscoveryService.stopListening();
      await centralManager.connect(event);
      _isConnected = true;

      final services = await centralManager.discoverGATT(event);
      for (var service in services) {
        if (service.uuid == BtAdvertisingService.serviceUuid) {
          _log.shout(
              'Connected to peripheral ${event.uuid}, discovering characteristics');
          for (GATTCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid ==
                BtAdvertisingService.gattCharacteristicsUuid) {
              _log.shout(
                  'Reading characteristic from peripheral ${event.uuid}');
              final data = await centralManager.readCharacteristic(
                  event, characteristic);

              whatTheyWant = SearchProfile.fromUint8List(data);
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
        if (_isConnected) {
          await centralManager.disconnect(event);
        }
      } catch (e) {
        _log.severe(
            'Error while disconnecting from peripheral ${event.uuid}: $e');
      } finally {
        _isConnected = false;
        await _btDiscoveryService.startListening();
      }
    }
    _log.shout('Disconnected from peripheral ${event.uuid}');
    return whatTheyWant;
  }

  bool _match(SearchProfile whatTheyWant) {
    return true;
  }
}
