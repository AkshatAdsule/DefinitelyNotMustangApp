import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/models/robot.dart';

class Team {
  String teamNumber, notes;
  DriveBaseType drivebaseType;
  bool innerPort,
      outerPort,
      bottomPort,
      rotationControl,
      positionControl,
      hasClimber,
      hasLeveller;

  Team({
    @required this.teamNumber,
    @required this.drivebaseType,
    @required this.notes,
    @required this.innerPort,
    @required this.outerPort,
    @required this.bottomPort,
    @required this.rotationControl,
    @required this.positionControl,
    @required this.hasClimber,
    @required this.hasLeveller,
  });

  factory Team.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return Team.fromJson(data);
  }

  factory Team.fromJson(Map<String, dynamic> data) {
    return Team(
      teamNumber: data['teamNumber'] ?? '',
      drivebaseType: Robot.driveBaseTypeFromString(data['drivebaseType']),
      notes: data['notes'] ?? '',
      innerPort: data['innerPort'],
      outerPort: data['outerPort'],
      bottomPort: data['bottomPort'],
      rotationControl: data['rotationControl'],
      positionControl: data['positionControl'],
      hasClimber: data['climber'],
      hasLeveller: data['leveller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': teamNumber,
      'drivebaseType': describeEnum(drivebaseType),
      'notes': notes,
      'innerPort': innerPort,
      'outerPort': outerPort,
      'bottomPort': bottomPort,
      'rotationControl': rotationControl,
      'positionControl': positionControl,
      'leveller': hasLeveller,
      'climber': hasClimber,
    };
  }
}
