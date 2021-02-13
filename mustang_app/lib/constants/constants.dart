import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  //not a constant but needs to be accessible
  static int fieldColor = 0;

  //DEFENSE ANAYLSIS
  static const double intakeValue = 1.5;
  static const double shotValue = 2; //avg of low, outer, inner
  static const double zoneDisplacementValue = 0.5;
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

  static int zoneRows = 8;
  static int zoneColumns = 16;

  //MAP ANALYSIS
  static const int shadingPointDifference = 2;
  static const double colorIncrement = 600 / shadingPointDifference;
  static const int minPtValuePerZone = 0;
  static const int maxPtValuePerZone = 5;
}
