import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// ViewModel for the [LogPage]
class LogPageViewModel extends ChangeNotifier {
  String _logText = '';
  late final StreamSubscription _streamSubscription;

  /// Creates an instance of this class
  LogPageViewModel() {
    _streamSubscription = Logger.root.onRecord.listen((record) {
      _logText += '${record.level.name}: ${record.time}: ${record.message}\n';
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  /// gets the log text that is shown in the UI
  String get logText => _logText;

  ///
  void clearLog() {
    _logText = '';
    notifyListeners();
  }
}
