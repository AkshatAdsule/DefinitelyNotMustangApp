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

enum ShootingCapability {
  LOWER,
  INNER,
  OUTER,
}

enum ClimbCapability {
  CLIMBER, 
  LEVELER
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
    DriveBaseType ret;
    DriveBaseType.values.forEach((element) {
      if (describeEnum(element) == driveBase) {
        ret = element;
      }
    });
    return ret ?? DriveBaseType.TANK;
  }

  static SecondarySubsystem secondarySubsystemFromString(
      String secondarySubsystem) {
    SecondarySubsystem ret;
    SecondarySubsystem.values.forEach((element) {
      if (describeEnum(element) == secondarySubsystem) {
        ret = element;
      }
    });
    return ret ?? SecondarySubsystem.AUTONOMOUS;
  }

  static OuttakeType outtakeTypeFromString(String outtakeType) {
    OuttakeType ret;
    OuttakeType.values.forEach((element) {
      if (describeEnum(element) == outtakeType) {
        ret = element;
      }
    });
    return ret ?? OuttakeType.SHOOTER;
  }
}
