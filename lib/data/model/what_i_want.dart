import 'dart:math';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:date_o_matic/data/model/gender.dart';
import 'package:date_o_matic/data/model/relationship_type.dart';
import 'package:logging/logging.dart';

/// This class contains a description of what this person is looking for. It
/// does not contain any personal data and will be send to others on request to
/// do the matching process.
class WhatIWant {
  final _log = Logger('BtState');

  /// A unique identifier of the partner.
  // TODO: generate unique UUID per device
  late int id = Random().nextInt(1 << 32);

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
    if (data.lengthInBytes > 0) {
      var bytes =
          ByteData.view(data.buffer, data.offsetInBytes, data.lengthInBytes);
      _log.shout('WhatIWant: received data ${bytes.toString()}');

      if (data.lengthInBytes == 26) {
        id = bytes.getUint64(0);
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
    bytes.setUint64(0, id);
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
