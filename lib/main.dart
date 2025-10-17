import 'dart:ui';

import 'package:date_o_matic/ioc_init.dart';
import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/ui/main_page/main_page.dart';
import 'package:date_o_matic/data/services/permission_service.dart';
import 'package:date_o_matic/ui/themes/dark_theme.dart';
import 'package:date_o_matic/ui/themes/light_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await _initializeApp();
  configureDependencies();

  runApp(const DateOMaticApp());
}

/// This is the main application widget and the starting point of all action.
/// It sets the theming, localization and so on.
class DateOMaticApp extends StatelessWidget {
  /// Creates an instance of this class.
  const DateOMaticApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localizationsDelegates = GlobalMaterialLocalizations.delegates.toList();
    localizationsDelegates.add(DateOMaticLocalizations.delegate);
    localizationsDelegates.add(GlobalWidgetsLocalizations.delegate);

    return MaterialApp(
      title: 'DateOMatic',
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: const [
        //the first entry is the default if the system locale doesn't match any in the list
        Locale('en'),
        Locale('de'),
      ],
      home: MainPage(title: 'DateOMatic App'),
    );
  }
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    name: 'DateOMatic',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await PermissionService.instance().request();
}
