import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'messages_localizations_de.dart';
import 'messages_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of DateOMaticLocalizations
/// returned by `DateOMaticLocalizations.of(context)`.
///
/// Applications need to include `DateOMaticLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/messages_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: DateOMaticLocalizations.localizationsDelegates,
///   supportedLocales: DateOMaticLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the DateOMaticLocalizations.supportedLocales
/// property.
abstract class DateOMaticLocalizations {
  DateOMaticLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static DateOMaticLocalizations? of(BuildContext context) {
    return Localizations.of<DateOMaticLocalizations>(
        context, DateOMaticLocalizations);
  }

  static const LocalizationsDelegate<DateOMaticLocalizations> delegate =
      _DateOMaticLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About DateOMatic'**
  String get about;

  /// No description provided for @openSourceComponents.
  ///
  /// In en, this message translates to:
  /// **'Open source components'**
  String get openSourceComponents;

  /// No description provided for @mainPageTitle.
  ///
  /// In en, this message translates to:
  /// **'DateOMatic'**
  String get mainPageTitle;

  /// No description provided for @debugPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debugPageTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @startAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Start Advertising'**
  String get startAdvertising;

  /// No description provided for @stopAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Stop Advertising'**
  String get stopAdvertising;

  /// No description provided for @startDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Start Discovery'**
  String get startDiscovery;

  /// No description provided for @stopDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Stop Discovery'**
  String get stopDiscovery;

  /// No description provided for @clearLog.
  ///
  /// In en, this message translates to:
  /// **'Clear Log'**
  String get clearLog;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @toggleOnlineOfflineTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle Online/Offline'**
  String get toggleOnlineOfflineTooltip;

  /// No description provided for @searchProfileEditPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Search Profile'**
  String get searchProfileEditPageTitle;

  /// No description provided for @searchProfileEditPageProfileName.
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get searchProfileEditPageProfileName;

  /// No description provided for @searchProfileEditPagePleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get searchProfileEditPagePleaseEnterName;

  /// No description provided for @searchProfileEditPageDesiredRelationshipType.
  ///
  /// In en, this message translates to:
  /// **'Desired Relationship Type'**
  String get searchProfileEditPageDesiredRelationshipType;

  /// No description provided for @searchProfileEditPageDesiredGender.
  ///
  /// In en, this message translates to:
  /// **'Desired Gender'**
  String get searchProfileEditPageDesiredGender;

  /// No description provided for @searchProfileEditPageBornFrom.
  ///
  /// In en, this message translates to:
  /// **'Born From (Earliest Date)'**
  String get searchProfileEditPageBornFrom;

  /// No description provided for @searchProfileEditPageBornTill.
  ///
  /// In en, this message translates to:
  /// **'Born Till (Latest Date)'**
  String get searchProfileEditPageBornTill;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @searchProfileListPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Profiles'**
  String get searchProfileListPageTitle;

  /// No description provided for @searchProfileListPageNoSearchProfilesFound.
  ///
  /// In en, this message translates to:
  /// **'No search profiles found.'**
  String get searchProfileListPageNoSearchProfilesFound;

  /// No description provided for @searchProfileListPageLookingFor.
  ///
  /// In en, this message translates to:
  /// **'Looking for {gender}, {relationshipType}\nBorn between {bornFrom} and {bornTill}'**
  String searchProfileListPageLookingFor(String gender, String relationshipType,
      DateTime bornFrom, DateTime bornTill);

  /// No description provided for @userProfileEditPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit User Profile'**
  String get userProfileEditPageTitle;

  /// No description provided for @userProfileEditPageProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'User Profile saved!'**
  String get userProfileEditPageProfileSaved;

  /// No description provided for @labelTextName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelTextName;

  /// No description provided for @userProfileEditPagePleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get userProfileEditPagePleaseEnterName;

  /// No description provided for @labelTextAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get labelTextAge;

  /// No description provided for @userProfileEditPagePleaseEnterAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age.'**
  String get userProfileEditPagePleaseEnterAge;

  /// No description provided for @labelTextGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get labelTextGender;

  /// No description provided for @labelTextHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (m)'**
  String get labelTextHeight;

  /// No description provided for @userProfileEditPagePleaseEnterHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your height.'**
  String get userProfileEditPagePleaseEnterHeight;

  /// No description provided for @labelTextWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get labelTextWeight;

  /// No description provided for @userProfileEditPagePleaseEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your weight.'**
  String get userProfileEditPagePleaseEnterWeight;

  /// No description provided for @userProfileEditPageHobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies (comma separated)'**
  String get userProfileEditPageHobbies;

  /// No description provided for @userProfileEditPageSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get userProfileEditPageSaveProfile;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @diverse.
  ///
  /// In en, this message translates to:
  /// **'Diverse'**
  String get diverse;

  /// No description provided for @serious.
  ///
  /// In en, this message translates to:
  /// **'Serious'**
  String get serious;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @friendsWithBenefits.
  ///
  /// In en, this message translates to:
  /// **'Friends with Benefits'**
  String get friendsWithBenefits;
}

class _DateOMaticLocalizationsDelegate
    extends LocalizationsDelegate<DateOMaticLocalizations> {
  const _DateOMaticLocalizationsDelegate();

  @override
  Future<DateOMaticLocalizations> load(Locale locale) {
    return SynchronousFuture<DateOMaticLocalizations>(
        lookupDateOMaticLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_DateOMaticLocalizationsDelegate old) => false;
}

DateOMaticLocalizations lookupDateOMaticLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return DateOMaticLocalizationsDe();
    case 'en':
      return DateOMaticLocalizationsEn();
  }

  throw FlutterError(
      'DateOMaticLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
