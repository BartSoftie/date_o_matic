import 'dart:collection';

import 'package:date_o_matic/data/model/what_i_want.dart';
import 'package:date_o_matic/data/repositories/user_profile_repository.dart';
import 'package:date_o_matic/ioc_init.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// ViewModel for the [MainPage]
class MainPageViewModel extends ChangeNotifier {
  //final _log = Logger('BtState');
  final UserProfileRepository _userProfileRepository =
      getIt<UserProfileRepository>();

  /// Creates an instance of this class
  MainPageViewModel() {
    //TODO: set the root log level somewhwere else
    Logger.root.level = Level.SEVERE;
    _userProfileRepository.isOnlineChanged.listen((event) {
      notifyListeners();
    });

    _userProfileRepository.profileDiscovered.listen((event) {
      // Handle discovered profile
      // For example, you might want to update the UI or store the profile
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userProfileRepository.dispose();
    super.dispose();
  }

  /// Returns `true` if the user is currently online (advertising or discovering), else `false`.
  bool get isOnline => _userProfileRepository.isOnline;

  /// Returns the list of discovered profiles.
  UnmodifiableListView<WhatIWant> get discoveredProfiles =>
      UnmodifiableListView(_userProfileRepository.whatTheyWantList);

  /// Toggles the online status of the user.
  void toggleOnline() {
    _userProfileRepository.toggleOnlineStatus().then((value) {
      notifyListeners();
    });
  }
}
