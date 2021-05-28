enum OuttakeType {
  SHOOTER,
  CLAW,
}

enum DriveBaseType { TANK, MECANUM }

enum SecondarySubsystem { COLOR_PICKER, VISION, AUTONOMOUS, CLIMBER, ELEVATOR }

class Robot {
  final DriveBaseType drivebaseType;
  final OuttakeType outtakeType;
  final List<SecondarySubsystem> secondarySubsystems;

  Robot({this.drivebaseType, this.outtakeType, this.secondarySubsystems});
}
