import 'package:date_o_matic/data/model/user_profile.dart';
import 'package:date_o_matic/data/services/hive_secure_service.dart';
import 'package:date_o_matic/ioc_init.dart';
import 'package:flutter/material.dart';
import 'package:date_o_matic/data/model/search_profile.dart';

/// Manages the list of SearchProfile objects and notifies listeners of changes.
class SearchProfileListViewModel extends ChangeNotifier {
  final _profileStorage = getIt<HiveSecureService>();
  final List<SearchProfile> _profiles = [];

  /// Creates an instance of [SearchProfileListViewModel] and loads existing profiles.
  SearchProfileListViewModel() {
    _loadProfiles();
  }

  void _loadProfiles() {
    final loadedProfiles = _profileStorage.searchProfiles;
    _profiles.addAll(loadedProfiles);
    notifyListeners();
  }

  /// Provides an unmodifiable view of the list of search profiles.
  List<SearchProfile> get profiles => List.unmodifiable(_profiles);

  /// Creates a new SearchProfile based on the existing UserProfile data.
  SearchProfile createNewProfile() {
    //TODO: move creation logic to repository. remove the two constructors from SearchProfile
    UserProfile? userProfile = _profileStorage.loadUserProfile();
    if (userProfile != null) {
      return SearchProfile.createFromUserProfile(userProfile);
    } else {
      return SearchProfile.createNewProfile();
    }
  }

  /// Adds a new profile to the list. (Optional for this task, but useful).
  void addProfile(SearchProfile newProfile) async {
    _profiles.add(newProfile);
    await _profileStorage.addSearchProfile(newProfile);
    notifyListeners();
  }

  /// Updates an existing profile in the list based on its profileId.
  /// Notifies listeners if the update was successful.
  void updateProfile(SearchProfile updatedProfile) async {
    final index =
        _profiles.indexWhere((p) => p.profileId == updatedProfile.profileId);
    if (index != -1) {
      _profiles[index] = updatedProfile;
      await _profileStorage.updateSearchProfile(updatedProfile);
      notifyListeners();
    }
  }

  /// Removes a profile from the list by its profileId.
  void removeProfile(int profileId) async {
    _profiles.removeWhere((p) => p.profileId == profileId);
    await _profileStorage.removeSearchProfile(profileId);
    notifyListeners();
  }
}
