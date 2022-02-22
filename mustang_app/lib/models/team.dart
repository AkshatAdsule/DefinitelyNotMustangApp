import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/robot.dart';

class Team {
  String teamNumber, teamName, teamEmail, region, notes;
  DriveBaseType drivebaseType;
  List<String> scoreLocations, intakeLocations, hubTargets, climbLocations;
  int autonBalls;

  Team({
    @required this.teamNumber,
    @required this.drivebaseType,
    this.notes = '',
    @required this.scoreLocations,
    @required this.intakeLocations,
    @required this.hubTargets,
    @required this.climbLocations,
    @required autonBalls,
    this.teamName,
    this.teamEmail,
    this.region,
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
      notes: data['notes'] ?? '',
      teamEmail: data['teamEmail'] ?? '',
      region: data['region'] ?? '',
      autonBalls: data["autonballs"] as int,
      climbLocations: (data["climbLocations"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      hubTargets: (data["hubTargets"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      intakeLocations: (data["intakeLocations"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      scoreLocations: (data["scoreLocations"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Team.fromPitScoutingState(Map<String, dynamic> state,
      {@required this.teamNumber, @required this.drivebaseType}) {
    this.climbLocations = [];
    this.hubTargets = [];
    this.scoreLocations = [];
    this.intakeLocations = [];
    for (var item in state.entries) {
      switch (item.key) {
        case "Auton Balls":
          this.autonBalls = int.parse(item.value);
          break;
        case "Against Fender":
        case "In Tarmac":
        case "Outside of Tarmac":
          if (item.value) {
            this.scoreLocations.add(item.key);
          }
          break;
        case "Field":
        case "Terminal":
          if (item.value) {
            this.intakeLocations.add(item.key);
          }
          break;
        case "Lower":
        case "Upper":
          if (item.value) {
            this.hubTargets.add(item.key);
          }
          break;
        case "Low":
        case "Middle":
        case "High":
        case "Traverse":
          if (item.value) {
            this.climbLocations.add(item.key);
          }
          break;
        case "Final Comments":
          this.notes = item.value;
          break;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': teamNumber,
      'drivebaseType': describeEnum(drivebaseType),
      'notes': notes,
      'teamName': teamName,
      'teamEmail': teamEmail,
      'region': region,
      'climbLocations': climbLocations,
      'scoreLocations': scoreLocations,
      'intakeLocations': intakeLocations,
      'hubTargets': hubTargets,
      'autonBalls': autonBalls,
    };
  }
}
