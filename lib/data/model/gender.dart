import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:hive/hive.dart';

part 'gender.g.dart';

/// An enum defining the differen genders.
@HiveType(typeId: 3)
enum Gender {
  /// Male
  @HiveField(0)
  male,

  /// Female
  @HiveField(1)
  female,

  /// Diverse
  @HiveField(2)
  diverse,
}

/// Returns the localized display name for a given Gender enum value.
String getLocalizedGenderName(
    Gender gender, DateOMaticLocalizations localizations) {
  switch (gender) {
    case Gender.male:
      return localizations.male;
    case Gender.female:
      return localizations.female;
    case Gender.diverse:
      return localizations.diverse;
  }
}
