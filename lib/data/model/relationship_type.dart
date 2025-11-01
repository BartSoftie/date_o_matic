import 'package:date_o_matic/l10n/generated/i18n/messages_localizations.dart';
import 'package:hive/hive.dart';

part 'relationship_type.g.dart';

/// Defines the kind of relationship someone is looking for.
@HiveType(typeId: 2)
enum RelationshipType {
  /// A long term relationship.
  @HiveField(0)
  serious,

  /// Just sex.
  @HiveField(1)
  casual,

  /// Occassional sex.
  @HiveField(2)
  friendsWithBenefits,
}

/// Returns the localized display name for a given RelationshipType enum value.
String getLocalizedRelationshipTypeName(
    RelationshipType relationshipType, DateOMaticLocalizations localizations) {
  switch (relationshipType) {
    case RelationshipType.serious:
      return localizations.serious;
    case RelationshipType.casual:
      return localizations.casual;
    case RelationshipType.friendsWithBenefits:
      return localizations.friendsWithBenefits;
  }
}
