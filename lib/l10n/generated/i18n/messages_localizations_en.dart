// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'messages_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class DateOMaticLocalizationsEn extends DateOMaticLocalizations {
  DateOMaticLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About DateOMatic';

  @override
  String get openSourceComponents => 'Open source components';

  @override
  String get mainPageTitle => 'DateOMatic';

  @override
  String get debugPageTitle => 'Debug';

  @override
  String get home => 'Home';

  @override
  String get debug => 'Debug';

  @override
  String get startAdvertising => 'Start Advertising';

  @override
  String get stopAdvertising => 'Stop Advertising';

  @override
  String get startDiscovery => 'Start Discovery';

  @override
  String get stopDiscovery => 'Stop Discovery';

  @override
  String get clearLog => 'Clear Log';

  @override
  String get myProfile => 'My Profile';

  @override
  String get profiles => 'Profiles';

  @override
  String get toggleOnlineOfflineTooltip => 'Toggle Online/Offline';

  @override
  String get searchProfileEditPageTitle => 'Edit Search Profile';

  @override
  String get searchProfileEditPageProfileName => 'Profile Name';

  @override
  String get searchProfileEditPagePleaseEnterName => 'Please enter a name.';

  @override
  String get searchProfileEditPageDesiredRelationshipType =>
      'Desired Relationship Type';

  @override
  String get searchProfileEditPageDesiredGender => 'Desired Gender';

  @override
  String get searchProfileEditPageBornFrom => 'Born From (Earliest Date)';

  @override
  String get searchProfileEditPageBornTill => 'Born Till (Latest Date)';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get searchProfileListPageTitle => 'Search Profiles';

  @override
  String get searchProfileListPageNoSearchProfilesFound =>
      'No search profiles found.';

  @override
  String searchProfileListPageLookingFor(String gender, String relationshipType,
      DateTime bornFrom, DateTime bornTill) {
    final intl.DateFormat bornFromDateFormat = intl.DateFormat.y(localeName);
    final String bornFromString = bornFromDateFormat.format(bornFrom);
    final intl.DateFormat bornTillDateFormat = intl.DateFormat.y(localeName);
    final String bornTillString = bornTillDateFormat.format(bornTill);

    return 'Looking for $gender, $relationshipType\nBorn between $bornFromString and $bornTillString';
  }

  @override
  String get userProfileEditPageTitle => 'Edit User Profile';

  @override
  String get userProfileEditPageProfileSaved => 'User Profile saved!';

  @override
  String get labelTextName => 'Name';

  @override
  String get userProfileEditPagePleaseEnterName => 'Please enter your name.';

  @override
  String get labelTextDateOfBirth => 'Date of Birth';

  @override
  String get userProfileEditPagePleaseEnterBirthday =>
      'Please enter your birthday.';

  @override
  String get labelTextGender => 'Gender';

  @override
  String get labelTextHeight => 'Height (m)';

  @override
  String get userProfileEditPagePleaseEnterHeight =>
      'Please enter your height.';

  @override
  String get labelTextWeight => 'Weight (kg)';

  @override
  String get userProfileEditPagePleaseEnterWeight =>
      'Please enter your weight.';

  @override
  String get userProfileEditPageHobbies => 'Hobbies (comma separated)';

  @override
  String get userProfileEditPageSaveProfile => 'Save Profile';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get diverse => 'Diverse';

  @override
  String get serious => 'Serious';

  @override
  String get casual => 'Casual';

  @override
  String get friendsWithBenefits => 'Friends with Benefits';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';
}
