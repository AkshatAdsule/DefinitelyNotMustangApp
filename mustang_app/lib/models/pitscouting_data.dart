import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/robot.dart';

class PitScoutingData {
  String teamNumber, teamName, teamEmail, region, notes, features;
  String q1, q2, q3, q4, q5, q6, q7, q8, q9;
  DriveBaseType drivebaseType;
  List<String> scoreLocations, intakeLocations, hubTargets, climbLocations;
  int autonBalls;

  static const List<String> ALL_INTAKE_LOCATIONS = ["Terminal", "Field"];
  static const List<String> ALL_SCORE_LOCATIONS = [
    "Against Fender",
    "In Tarmac",
    "Outside Tarmac"
  ];
  static const List<String> ALL_HUB_TARGETS = ["Lower", "Upper"];
  static const List<String> ALL_CLIMB_LEVELS = [
    "Low",
    "Middle",
    "High",
    "Traverse"
  ];
  static const List<List<String>> ALL_CRITERIA = [
    ALL_INTAKE_LOCATIONS,
    ALL_SCORE_LOCATIONS,
    ALL_HUB_TARGETS,
    ALL_CLIMB_LEVELS
  ];

  PitScoutingData(
      {@required this.teamNumber,
      @required this.drivebaseType,
      this.notes = '',
      @required this.scoreLocations,
      @required this.intakeLocations,
      @required this.hubTargets,
      @required this.climbLocations,
      @required this.autonBalls,
      @required this.q1,
      @required this.q2,
      @required this.q3,
      @required this.q4,
      @required this.q5,
      @required this.q6,
      @required this.q7,
      @required this.q8,
      @required this.q9,
      this.teamName,
      this.teamEmail,
      this.region,
      this.features});

  factory PitScoutingData.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return PitScoutingData.fromJson(data);
  }

  factory PitScoutingData.fromJson(Map<String, dynamic> data) {
    return PitScoutingData(
      teamNumber: data['teamNumber'] ?? '',
      teamName: data['teamName'] ?? '',
      drivebaseType: Robot.driveBaseTypeFromString(data['drivebaseType']),
      notes: data['notes'] ?? '',
      teamEmail: data['teamEmail'] ?? '',
      region: data['region'] ?? '',
      autonBalls: data["autonBalls"],
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
      features: data["features"] ?? "",
      q1: data["q1"] ?? "",
      q2: data["q2"] ?? "",
      q3: data["q3"] ?? "",
      q4: data["q4"] ?? "",
      q5: data["q5"] ?? "",
      q6: data["q6"] ?? "",
      q7: data["q7"] ?? "",
      q8: data["q8"] ?? "",
      q9: data["q9"] ?? "",
    );
  }

  PitScoutingData.fromPitScoutingState(Map<String, dynamic> state,
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
        case "Robot Features":
          this.features = item.value;
          break;
        case "q1":
          this.q1 = item.value;
          break;
        case "q2":
          this.q2 = item.value;
          break;
        case "q3":
          this.q3 = item.value;
          break;
        case "q4":
          this.q4 = item.value;
          break;
        case "q5":
          this.q5 = item.value;
          break; 
        case "q6":
          this.q6 = item.value;
          break; 
        case "q7":
          this.q7 = item.value;
          break;  
        case "q8":
          this.q8 = item.value;
          break;
        case "q9":
          this.q9 = item.value;
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
      'features': features,
      'q1': q1,
      'q2': q2,
      'q3': q3,
      'q4': q4,
      'q5': q5,
      'q6': q6,
      'q7': q7,
      'q8': q8,
      'q9': q9,

    };
  }
}
