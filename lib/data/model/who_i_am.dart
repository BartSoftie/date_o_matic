import 'package:date_o_matic/data/model/gender.dart';

/// This class contains all the required information about the person owning
/// this device. It is used for the matching process.
class WhoIAm {
  String age = '';
  Gender gender = Gender.diverse;
  double height = 1.8;
  double weight = 80.0; //or something that describes the shape
  String hobbies = '';
}
