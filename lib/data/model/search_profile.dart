import 'dart:typed_data';

import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

part 'search_profile.g.dart';

/// This class contains a description of what this person is looking for. It
/// does not contain any personal data and will be send to others on request to
/// do the matching process.
@HiveType(typeId: 1)
class SearchProfile {
  final _log = Logger('BtState');

  /// A unique identifier of this search profile.
  @HiveField(0)
  late final int profileId;

  /// The name of this search profile.
  @HiveField(6)
  late final String name;

  /// A unique identifier of the apps user who is searching for a match.
  /// It can be used during matching to identify the user.
  @HiveField(1)
  late final int userId;

  /// The [RelationshipType] a person is looking for.
  @HiveField(2)
  late final RelationshipType relationshipType;

  /// The [Gender] a person is looking for.
  @HiveField(3)
  late final Gender gender;

  /// The person who we are looking for must not be born before this date.
  @HiveField(4)
  late final DateTime bornFrom;

  /// The person who we are looking for must not be born after this date.
  @HiveField(5)
  late final DateTime bornTill;

  /// Creates an unmodifyable instance of this class with the given parameters.
  SearchProfile(
      //TODO: make profileId optional and generate it automatically
      //use maybe two constructors. one for creating new profile with new id
      //one for loading existing profile with given id
      {required this.profileId,
      required this.userId,
      required this.name,
      required this.relationshipType,
      required this.gender,
      required this.bornFrom,
      required this.bornTill});

  /// Crates an instance of this type from the given packed [Uint8List].
  SearchProfile.fromUint8List(Uint8List data) {
    if (data.lengthInBytes > 0) {
      var bytes =
          ByteData.view(data.buffer, data.offsetInBytes, data.lengthInBytes);
      _log.shout('WhatIWant: received data ${bytes.toString()}');

      if (data.lengthInBytes == 26) {
        userId = bytes.getUint64(0);
        relationshipType = RelationshipType.values[bytes.getUint8(8)];
        gender = Gender.values[bytes.getUint8(9)];
        bornFrom = DateTime.fromMicrosecondsSinceEpoch(bytes.getInt64(10));
        bornTill = DateTime.fromMicrosecondsSinceEpoch(bytes.getInt64(18));
        _log.shout('WhatIWant: ${toString()}');
      } else {
        _log.shout('WhatIWant: invalid bytes length: ${bytes.lengthInBytes}');
        //TODO: maybe use nullable here to avoid initialization if invalid input
        relationshipType = RelationshipType.casual;
        gender = Gender.diverse;
        bornFrom = DateTime.now();
        bornTill = DateTime.now();
      }
    } else {
      _log.shout('WhatIWant: received 0 bytes');
      //TODO: maybe use nullable here to avoid initialization if invalid input
      relationshipType = RelationshipType.casual;
      gender = Gender.diverse;
      bornFrom = DateTime.now();
      bornTill = DateTime.now();
    }
  }

  /// Returns this object as packed [Uint8List].
  Uint8List asUint8List() {
    var bytes = ByteData(26);
    bytes.setUint64(0, userId);
    bytes.setUint8(8, relationshipType.index);
    bytes.setUint8(9, gender.index);
    bytes.setInt64(10, bornFrom.microsecondsSinceEpoch);
    bytes.setInt64(18, bornTill.microsecondsSinceEpoch);
    return bytes.buffer.asUint8List();
  }

  /// Returns a string representation of this object.
  @override
  String toString() {
    return 'Relationship Type: $relationshipType\nGender: $gender\nBornFrom: $bornFrom\nBornTill: $bornTill';
  }
}
