class Constants {
  //not a constant but needs to be accessible
  static int fieldColor = 0;

  // Pre event analysis data version
  static const double DATA_ANALYSIS_DATA_VERSION = 1.0;

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

  // Game length refers to auton + teleop
  static const int GAME_LENGTH = 150; //seconds

  static const Map<int, List<RobotFeatures>> ROBOT_FEATURES = {
    2013: [RobotFeatures.SHOOTER],
    2014: [RobotFeatures.SHOOTER],
    2015: [RobotFeatures.ELEVATOR],
    2016: [RobotFeatures.SHOOTER],
    2017: [RobotFeatures.CLIMBER, RobotFeatures.SHOOTER],
    2018: [RobotFeatures.CLIMBER, RobotFeatures.ELEVATOR],
    2019: [
      RobotFeatures.SHOOTER,
      RobotFeatures.ELEVATOR,
      RobotFeatures.CLAW,
      RobotFeatures.CLIMBER
    ],
    2020: [RobotFeatures.SHOOTER, RobotFeatures.CLIMBER]
  };

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

  //DEFENSE ANAYLSIS
  static const double intakeValue = 1.5;
  static const double shotValue = 2; //avg of low, outer, inner
  static const double zoneDisplacementValue = 0.5;
  static const double maxBallsInBot = 5; //ie max number of balls in bot is 5
  static const double regFoul = -3;
  static const double techFoul = -15;
  static const double yellowCard = -20;
  static const double redCard = -40;

  //speed in feet per second
  //TODO: SETTING EVERYTHING TO 10 FOR NOW, UPDATE LATER!!
  static const double tankSpeed = 10;
  static const double omniSpeed = 10;
  static const double westCoastSpeed = 10;
  static const double mecanumSpeed = 10;
  static const double swerveSpeed = 10;

  static const double zoneSideLength = 3.3;

  //OFFENSE ANALYSIS
  static const double autonMillisecondLength = 15000;
  static const double crossInitiationLineValue = 5;
  static const double lowShotAutonValue = 2;
  static const double outerShotAutonValue = 4;
  static const double innerShotAutonValue = 6;
  static const double lowShotValue = 1;
  static const double outerShotValue = 2;
  static const double innerShotValue = 3;
  static const double rotationControl = 15;
  static const double positionControl = 20;
  static const double climbValue = 25;
  static const double endgameParkValue = 5;

  static const int zoneRows = 8;
  static const int zoneColumns = 16;

  //MAP ANALYSIS
  static const int shadingPointDifference = 2;
  static const double colorIncrement = 600 / shadingPointDifference;
  static const int minPtValuePerZonePerGame = 0;
  static const int maxPtValuePerZonePerGame = 5;

  // MAP SCOUTING
  static const int teleopStartMillis = 15000;
  static const int endgameStartMillis = 120000;
  static const int matchEndMillis = 150000;
  static const int stopwatchLagMillis = 2000;

  static const Duration offlineTimeoutMillis = Duration(milliseconds: 5000);

  // CREDITS
  static const List<String> creators = [
    "Akshat Adsule",
    "Antonio Cuan",
    "Arnav Kulkarni",
    "Elise Vambenepe",
    "Laksh Bhambhani",
    "Katia Bravo",
    "Tarini Maram",
  ];
}

enum RobotFeatures { CLAW, SHOOTER, ELEVATOR, CLIMBER }
