import 'package:flutter/foundation.dart';

enum OuttakeType {
  SHOOTER,
  CLAW,
}

enum DriveBaseType {
  TANK,
  OMNI,
  WESTCOAST,
  MECANUM,
  SWERVE,
}

enum SecondarySubsystem {
  COLOR_PICKER,
  VISION,
  AUTONOMOUS,
  CLIMBER,
  ELEVATOR,
}

class Robot {
  final DriveBaseType drivebaseType;
  final OuttakeType outtakeType;
  final List<SecondarySubsystem> secondarySubsystems;

  Robot({
    @required this.drivebaseType,
    @required this.outtakeType,
    @required this.secondarySubsystems,
  });

  Map<String, dynamic> toJson() {
    return {
      'drivebaseType': describeEnum(drivebaseType),
      'outtakeType': describeEnum(outtakeType),
      'secondarySubsysteams':
          secondarySubsystems.map((e) => describeEnum(e)).toList(),
    };
  }

  factory Robot.fromJson(Map<String, dynamic> data) {
    return Robot(
      drivebaseType: driveBaseTypeFromString(data['drivebaseType']),
      outtakeType: outtakeTypeFromString(data['outtakeType']),
      secondarySubsystems: (data['secondarySubsystems'] as List<String>)
          .map((e) => secondarySubsystemFromString(e))
          .toList(),
    );
  }

  static DriveBaseType driveBaseTypeFromString(String driveBase) {
    DriveBaseType.values.forEach((element) {
      if (describeEnum(element) == driveBase) {
        return element;
      }
    });
    return DriveBaseType.TANK;
  }

  static SecondarySubsystem secondarySubsystemFromString(
      String secondarySubsystem) {
    SecondarySubsystem.values.forEach((element) {
      if (describeEnum(element) == secondarySubsystem) {
        return element;
      }
    });
    return SecondarySubsystem.AUTONOMOUS;
  }

  static OuttakeType outtakeTypeFromString(String outtakeType) {
    OuttakeType.values.forEach((element) {
      if (describeEnum(element) == outtakeType) {
        return element;
      }
    });
    return OuttakeType.SHOOTER;
  }
}
