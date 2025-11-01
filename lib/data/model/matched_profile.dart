import 'package:date_o_matic/data/model/search_profile.dart';

/// This class represents a profile that has been matched with our profile.
class MatchedProfile {
  final SearchProfile profile;
  final double matchScore;
  final DateTime lastSeen;
  final int rssi;

  /// Creates an instance of this class.
  MatchedProfile(
      {required this.profile,
      required this.matchScore,
      required this.lastSeen,
      required this.rssi});

  @override
  String toString() {
    return 'MatchedProfile(profile: ${profile.toString()}, matchScore: $matchScore, lastSeen: $lastSeen, rssi: $rssi)';
  }
}
