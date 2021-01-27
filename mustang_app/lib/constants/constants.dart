import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  static Firestore db = Firestore.instance;

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
  static const double numColumns = 16;
  static const double numRows = 8;

  //OFFENSE ANALYSIS
  static const double lowShotValue = 1;
  static const double outerShotValue = 2;
  static const double innerShotValue = 3;
  static const double rotationControl = 15;
  static const double positionControl = 20;

}
