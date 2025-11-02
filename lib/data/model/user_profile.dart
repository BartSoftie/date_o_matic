import 'dart:math';

import 'package:date_o_matic/data/model/gender.dart';
import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// This class contains all the required information about the person owning
/// this device. It is used for the matching process.
@HiveType(typeId: 0)
class UserProfile {
  static final int userId = Random().nextInt(1 << 32);

  /// The name of this person.
  @HiveField(0)
  String name = '';

  /// The age of this person.
  @HiveField(1)
  String age = '';

  /// The gender of this person.
  @HiveField(2)
  Gender gender = Gender.diverse;

  /// The height of this person in meters.
  @HiveField(3)
  double height = 1.8;

  /// The weight of this person in kilograms.
  @HiveField(4)
  double weight = 80.0; //or something that describes the shape

  /// The hobbies of this person.
  @HiveField(5)
  String hobbies = '';
}
