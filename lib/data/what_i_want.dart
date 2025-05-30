import 'dart:typed_data';

import 'package:date_o_matic/data/gender.dart';
import 'package:date_o_matic/data/relationship_type.dart';

/// This class contains a description of what this person is looking for. It
/// does not contain any personal data and will be send to others on request to
/// do the matching process.
class WhatIWant {
  /// The [RelationshipType] a person is looking for.
  late final RelationshipType relationshipType;

  /// The [Gender] a person is looking for.
  late final Gender gender;

  /// The person who we are looking for must not be born before this date.
  late final DateTime bornFrom;

  /// The person who we are looking for must not be born after this date.
  late final DateTime bornTill;

  /// Creates an unmodifyable instance of this class with the given parameters.
  WhatIWant(
      {required this.relationshipType,
      required this.gender,
      required this.bornFrom,
      required this.bornTill});

  /// Crates an instance of this type from the given packed [Uint8List].
  WhatIWant.fromUint8List(Uint8List data) {
    var bytes =
        ByteData.view(data.buffer, data.offsetInBytes, data.lengthInBytes);
    //TODO: range check the following two
    relationshipType = RelationshipType.values[bytes.getUint8(0)];
    gender = Gender.values[bytes.getUint8(1)];
    bornFrom = DateTime.fromMicrosecondsSinceEpoch(bytes.getInt64(2));
    bornTill = DateTime.fromMicrosecondsSinceEpoch(bytes.getInt64(10));
  }

  /// Returns this object as packed [Uint8List].
  Uint8List asUint8List() {
    var bytes = ByteData(18);
    bytes.setUint8(0, relationshipType.index);
    bytes.setUint8(1, gender.index);
    bytes.setInt64(2, bornFrom.microsecondsSinceEpoch);
    bytes.setInt64(10, bornTill.microsecondsSinceEpoch);
    return bytes.buffer.asUint8List();
  }

  /// Returns a string representation of this object.
  @override
  String toString() {
    return 'Relationship Type: $relationshipType\nGender: $gender\nBornFrom: $bornFrom\nBornTill: $bornTill';
  }
}
