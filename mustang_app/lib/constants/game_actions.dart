import 'package:flutter/cupertino.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/pages/pages.dart';

class RobotAction {
  String text;
  Function onPress;

  RobotAction(String text, Function onPress) {
    this.onPress = onPress;
    this.text = text;
  }
}

class GameActions {
  static List<RobotAction> climbActions = [
    RobotAction(
      "No Park",
      (MapScoutingState currentState) {
        currentState.addClimb(ActionType.OTHER_CLIMB_MISS);
      },
    ),
    RobotAction(
      "Parked",
      (MapScoutingState currentState) {
        currentState.addClimb(ActionType.OTHER_PARKED);
      },
    ),
    RobotAction(
      "Climbed",
      (MapScoutingState currentState) {
        currentState.addClimb(ActionType.OTHER_CLIMB);
      },
    ),
    RobotAction(
      "Levelled",
      (MapScoutingState currentState) {
        currentState.addClimb(ActionType.OTHER_LEVELLED);
      },
    ),
  ];
}
