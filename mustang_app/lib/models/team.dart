

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/models/robot.dart';

class Team {
  String teamNumber, teamName, teamEmail, region, notes;
  String batteryCapacity, chargeCapacity, newTools, storageInfo, looks;
  // ignore: deprecated_member_use
  var programmingLanguage = ['Java', 'Python', 'C', 'C++', 'Other'];
  var shootingCapacity = ['Upper Port', 'Lower Port'];
  Robot robot;
  

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
    this.notes = '',
    @required this.innerPort,
    @required this.outerPort,
    @required this.bottomPort,
    @required this.rotationControl,
    @required this.positionControl,
    @required this.hasClimber,
    @required this.hasLeveller,
    this.teamName,
    this.teamEmail,
    this.region,
    @required this.batteryCapacity,
    @required this.chargeCapacity,
    @required this.newTools,
    @required this.storageInfo,
    @required this.looks,
    @required this.robot,
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
      teamName: data['teamName'] ?? '',
      drivebaseType: Robot.driveBaseTypeFromString(data['drivebaseType']),
    //  notes: data['notes'] ?? '',
      innerPort: data['innerPort'],
      outerPort: data['outerPort'],
      bottomPort: data['bottomPort'],
      rotationControl: data['rotationControl'],
      positionControl: data['positionControl'],
      hasClimber: data['climber'],
      hasLeveller: data['leveller'],
      teamEmail: data['teamEmail'] ?? '',
      region: data['region'] ?? '',
      batteryCapacity: data['batteryCapacity'] ?? '',
      chargeCapacity: data['chargeCapacity'] ?? '',
      newTools: data['newTools'] ?? '',
      storageInfo: data['storageInfo'] ?? '',
      looks: data['looks'] ?? '',
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': teamNumber,
      'drivebaseType': describeEnum(drivebaseType),
      'innerPort': innerPort,
      'outerPort': outerPort,
      'bottomPort': bottomPort,
      'rotationControl': rotationControl,
      'positionControl': positionControl,
      'leveller': hasLeveller,
      'climber': hasClimber,
      'teamName': teamName,
      'teamEmail': teamEmail,
      'region': region,
      'batteryCapacity': batteryCapacity,
      'chargeCapacity': chargeCapacity,
      'newTools': newTools,
      'storageInfo': storageInfo,
      'looks': looks, 
      'notes': notes,
    };
  }
}
