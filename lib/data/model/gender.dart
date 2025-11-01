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
