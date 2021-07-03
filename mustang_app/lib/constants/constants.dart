export 'game_constants.dart';
export 'preferences.dart';
export 'legacy.dart';
export 'robot_constants.dart';
import 'package:mustang_app/models/robot.dart';

class Constants {
  //not a constant but needs to be accessible
  static int fieldColor = 0;

  // Pre event analysis data version
  static const double DATA_ANALYSIS_DATA_VERSION = 1.3;

  // Data collection analysis data version
  static const double DATA_COLLECTION_DATA_VERSION = 1.0;

  // Validity threshold
  static const int DATA_VALIDITY_THRESHOLD = 3;

  // Data collection constants
  static const Map<int, double> GAME_PIECE_VALUE = {
    2013: 4,
    2014: 10,
    2015: 4,
    2016: 5,
    2017: 0.1667,
    2018: 1,
    2019: 2.5,
    2020: 2,
  };

  static final Map<int, Robot> robots = {
    2013: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [],
    ),
    2014: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [],
    ),
    2015: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [SecondarySubsystem.ELEVATOR],
    ),
    2016: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [],
    ),
    2017: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [
        SecondarySubsystem.CLIMBER,
        SecondarySubsystem.AUTONOMOUS
      ],
    ),
    2018: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.SHOOTER,
      secondarySubsystems: [
        SecondarySubsystem.CLIMBER,
        SecondarySubsystem.ELEVATOR,
        SecondarySubsystem.AUTONOMOUS
      ],
    ),
    2019: Robot(
      drivebaseType: DriveBaseType.TANK,
      outtakeType: OuttakeType.CLAW,
      secondarySubsystems: [
        SecondarySubsystem.CLIMBER,
        SecondarySubsystem.ELEVATOR,
        SecondarySubsystem.COLOR_PICKER,
        SecondarySubsystem.AUTONOMOUS
      ],
    ),
    2020: Robot(
        drivebaseType: DriveBaseType.TANK,
        outtakeType: OuttakeType.SHOOTER,
        secondarySubsystems: [
          SecondarySubsystem.AUTONOMOUS,
          SecondarySubsystem.VISION,
          SecondarySubsystem.CLIMBER,
          SecondarySubsystem.AUTONOMOUS
        ])
  };

  // Game length refers to auton + teleop
  static const int GAME_LENGTH = 150; //seconds

  // Points scored by climbing
  static const Map<int, int> CLIMB_POINTS = {
    2013: 20,
    2014: 0,
    2015: 0,
    2016: 15,
    2017: 50,
    2018: 30,
    2019: 6,
    2020: 25,
  };
}
