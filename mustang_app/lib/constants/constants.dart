class Constants {
  //not a constant but needs to be accessible
  static int fieldColor = 0;

  // Pre event analysis data version
  static const double DATA_ANALYSIS_DATA_VERSION = 1.0;

  // Data collection analysis data version
  static const double DATA_COLLECTION_DATA_VERSION = 1.0;

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
