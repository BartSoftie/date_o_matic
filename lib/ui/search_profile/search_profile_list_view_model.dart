import 'package:flutter/material.dart';
import 'package:date_o_matic/data/model/search_profile.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:date_o_matic/data/model/gender.dart';

/// Manages the list of SearchProfile objects and notifies listeners of changes.
class SearchProfileListViewModel extends ChangeNotifier {
  // Simulating initial data for demonstration purposes
  final List<SearchProfile> _profiles = [
    SearchProfile(
      profileId: 1,
      userId: 101,
      name: 'Weekend Buddy',
      relationshipType: RelationshipType.casual,
      gender: Gender.female,
      bornFrom: DateTime(1995, 1, 1),
      bornTill: DateTime(2005, 12, 31),
    ),
    SearchProfile(
      profileId: 2,
      userId: 101,
      name: 'Serious Relationship',
      relationshipType: RelationshipType.serious,
      gender: Gender.male,
      bornFrom: DateTime(1980, 1, 1),
      bornTill: DateTime(1994, 12, 31),
    ),
  ];

  /// Provides an unmodifiable view of the list of search profiles.
  List<SearchProfile> get profiles => List.unmodifiable(_profiles);

  /// Updates an existing profile in the list based on its profileId.
  /// Notifies listeners if the update was successful.
  void updateProfile(SearchProfile updatedProfile) {
    final index =
        _profiles.indexWhere((p) => p.profileId == updatedProfile.profileId);
    if (index != -1) {
      _profiles[index] = updatedProfile;
      notifyListeners();
    }
  }

  /// Adds a new profile to the list. (Optional for this task, but useful).
  void addProfile(SearchProfile newProfile) {
    _profiles.add(newProfile);
    notifyListeners();
  }
}
