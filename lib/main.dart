import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:date_o_matic/presentation/main_page/my_home_page.dart';
import 'package:date_o_matic/themes/dark_theme.dart';
import 'package:date_o_matic/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await _initializeApp();

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
      localizationsDelegates: localizationsDelegates,
      supportedLocales: const [
        //the first entry is the default if the system locale doesn't match any in the list
        Locale('en'),
        Locale('de'),
      ],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO: enable firebase crashlytics
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothAdvertise.request();
}
