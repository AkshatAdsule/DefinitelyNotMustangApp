import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/robot.dart';

class PitScoutingData {
  String teamNumber,
      teamName,
      teamEmail,
      region,
      notes,
      features,
      autonRoutine,
      accuracy,
      driverExperience,
      imageURL;
  DriveBaseType drivebaseType;
  List<String> scoreLocations, intakeLocations, hubTargets, climbLocations;
  int autonBalls;
  bool badFalcons;

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
    "Traversal"
  ];
  static const List<List<String>> ALL_CRITERIA = [
    ALL_INTAKE_LOCATIONS,
    ALL_SCORE_LOCATIONS,
    ALL_HUB_TARGETS,
    ALL_CLIMB_LEVELS
  ];

  PitScoutingData({
    @required this.teamNumber,
    @required this.drivebaseType,
    @required this.notes,
    @required this.scoreLocations,
    @required this.intakeLocations,
    @required this.hubTargets,
    @required this.climbLocations,
    @required this.autonBalls,
    @required this.autonRoutine,
    @required this.teamName,
    @required this.teamEmail,
    @required this.region,
    @required this.features,
    @required this.accuracy,
    @required this.driverExperience,
    @required this.badFalcons,
    @required this.imageURL,
  });

  factory PitScoutingData.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return PitScoutingData.fromJson(data);
  }

  factory PitScoutingData.fromJson(Map<String, dynamic> data) {
    return PitScoutingData(
        teamNumber: data['teamNumber'] ?? "",
        teamName: data['teamName'] ?? "",
        drivebaseType: Robot.driveBaseTypeFromString(data['drivebaseType']),
        notes: data['notes'] ?? '',
        teamEmail: data['teamEmail'] ?? "",
        region: data['region'] ?? "",
        autonBalls: data["autonBalls"] ?? 0,
        accuracy: data["accuracy"] ?? "",
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
        driverExperience: data["driverExperience"] ?? "",
        autonRoutine: data["autonRoutine"] ?? "",
        badFalcons: data["bad_falcons"] ?? false,
        imageURL: data["imageURL"] ?? "");
  }

  PitScoutingData.fromPitScoutingState(Map<String, dynamic> state,
      {@required this.teamNumber,
      @required this.drivebaseType,
      @required this.imageURL}) {
    this.climbLocations = [];
    this.hubTargets = [];
    this.scoreLocations = [];
    this.intakeLocations = [];
    for (var item in state.entries) {
      switch (item.key) {
        case "Auton Balls":
          this.autonBalls = int.parse(item.value);
          break;
        case "auton_routine":
          this.autonRoutine = item.value;
          break;
        case "Against Fender":
        case "In Tarmac":
        case "Outside Tarmac":
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
        case "Traversal":
          if (item.value) {
            this.climbLocations.add(item.key);
          }
          break;
        case "driver_experience":
          this.driverExperience = item.value;
          break;
        case "quoted_accuracy":
          this.accuracy = item.value;
          break;
        case "Final Comments":
          this.notes = item.value;
          break;
        case "features":
          this.features = item.value;
          break;
        case "Final Comments":
          this.notes = item.value;
          break;
        case "bad_falcons":
          this.badFalcons = item.value ?? false;
          break;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': teamNumber,
      'drivebaseType': describeEnum(drivebaseType),
      'notes': notes ?? "",
      'teamName': teamName,
      'teamEmail': teamEmail,
      'region': region,
      'climbLocations': climbLocations ?? [],
      'scoreLocations': scoreLocations ?? [],
      'intakeLocations': intakeLocations ?? [],
      'hubTargets': hubTargets ?? [],
      'autonBalls': autonBalls ?? -1,
      'features': features ?? "",
      'autonRoutine': autonRoutine ?? "",
      'accuracy': accuracy ?? "",
      'driverExperience': driverExperience ?? "",
      'badFalcons': badFalcons ?? false,
      'imageURL': imageURL ?? ""
    };
  }
}
