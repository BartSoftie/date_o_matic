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
    Logger.root.level = Level.WARNING;
    _userProfileRepository.isOnlineChanged.listen((event) {
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

  /// Toggles the online status of the user.
  void toggleOnline() {
    _userProfileRepository.toggleOnlineStatus();
    notifyListeners();
  }
}
