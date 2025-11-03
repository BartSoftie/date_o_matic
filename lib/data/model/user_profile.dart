import 'package:date_o_matic/data/model/gender.dart';
import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// This class contains all the required information about the person owning
/// this device. It is used for the matching process.
@HiveType(typeId: 0)
class UserProfile {
  /// A unique identifier of the apps user.
  static int userId = 0;

  /// The date of birth of this person.
  @HiveField(0)
  DateTime dateOfBirth =
      DateTime.now().subtract(const Duration(days: 365 * 25));

  /// The gender of this person.
  @HiveField(1)
  Gender gender = Gender.diverse;

  /// The height of this person in meters.
  @HiveField(2)
  double height = 1.8;

  /// The weight of this person in kilograms.
  @HiveField(3)
  double weight = 80.0; //or something that describes the shape

  /// The hobbies of this person.
  @HiveField(4)
  String hobbies = '';
}
