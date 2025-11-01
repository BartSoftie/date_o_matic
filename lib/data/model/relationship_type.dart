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
