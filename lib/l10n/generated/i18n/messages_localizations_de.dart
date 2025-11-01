// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'messages_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class DateOMaticLocalizationsDe extends DateOMaticLocalizations {
  DateOMaticLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über DateOMatic';

  @override
  String get openSourceComponents => 'Open Source Komponenten';

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
  String get clearLog => 'Log löschen';

  @override
  String get myProfile => 'Mein Profil';

  @override
  String get profiles => 'Profile';

  @override
  String get toggleOnlineOfflineTooltip => 'Toggle Online/Offline';

  @override
  String get searchProfileEditPageTitle => 'Suchprofil bearbeiten';

  @override
  String get searchProfileEditPageProfileName => 'Profilname';

  @override
  String get searchProfileEditPagePleaseEnterName =>
      'Bitte einen Namen eingeben.';

  @override
  String get searchProfileEditPageDesiredRelationshipType =>
      'Gewünschte Beziehungsart';

  @override
  String get searchProfileEditPageDesiredGender => 'Gewünschtes Geschlecht';

  @override
  String get searchProfileEditPageBornFrom => 'Geboren ab (ältester Tag)';

  @override
  String get searchProfileEditPageBornTill => 'Geboren bis (jüngster Tag)';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get searchProfileListPageTitle => 'Suchprofile';

  @override
  String get searchProfileListPageNoSearchProfilesFound =>
      'Kein Suchprofil gefunden.';

  @override
  String searchProfileListPageLookingFor(String gender, String relationshipType,
      DateTime bornFrom, DateTime bornTill) {
    final intl.DateFormat bornFromDateFormat = intl.DateFormat.y(localeName);
    final String bornFromString = bornFromDateFormat.format(bornFrom);
    final intl.DateFormat bornTillDateFormat = intl.DateFormat.y(localeName);
    final String bornTillString = bornTillDateFormat.format(bornTill);

    return 'Suche nach $gender, $relationshipType\nGeboren von $bornFromString bis $bornTillString';
  }

  @override
  String get userProfileEditPageTitle => 'Benutzerprofil bearbeiten';

  @override
  String get userProfileEditPageProfileSaved => 'Benutzerprofil gespeichert!';

  @override
  String get labelTextName => 'Name';

  @override
  String get userProfileEditPagePleaseEnterName =>
      'Bitte geben Sie Ihren Namen ein.';

  @override
  String get labelTextAge => 'Age';

  @override
  String get userProfileEditPagePleaseEnterAge =>
      'Bitte geben Sie Ihr Alter ein.';

  @override
  String get labelTextGender => 'Geschlecht';

  @override
  String get labelTextHeight => 'Größe (m)';

  @override
  String get userProfileEditPagePleaseEnterHeight =>
      'Bitte geben Sie Ihre Größe ein.';

  @override
  String get labelTextWeight => 'Gewicht (kg)';

  @override
  String get userProfileEditPagePleaseEnterWeight =>
      'Bitte geben Sie Ihr Gewicht ein.';

  @override
  String get userProfileEditPageHobbies => 'Hobbys (kommagetrennt)';

  @override
  String get userProfileEditPageSaveProfile => 'Profil speichern';
}
