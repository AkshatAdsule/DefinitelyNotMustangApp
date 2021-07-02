import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameAction {
  //end row, end column, push time are only for push, will be null most of time
  double timeStamp, x, y, pushTime;
  ActionType actionType;
  GameAction(
      {@required this.actionType,
      @required this.timeStamp,
      @required this.x,
      @required this.y,
      this.pushTime = 0});

  factory GameAction.other(ActionType actionType, double timeStamp) {
    return GameAction(
        actionType: actionType, timeStamp: timeStamp, x: -1, y: -1);
  }

  String toString() {
    return "Type: " +
        actionType.toString() +
        "; Duration: " +
        timeStamp.toString() +
        "; Location: (" +
        x.toString() +
        ", " +
        y.toString() +
        ")";
  }

  Map<String, dynamic> toJson() {
    return {
      'timeStamp': timeStamp,
      'x': x,
      'y': y,
      'pushTime': pushTime,
      'actionType': describeEnum(actionType),
    };
  }

  factory GameAction.fromJson(Map<String, dynamic> data) {
    return GameAction(
      x: data['x'],
      y: data['y'],
      timeStamp: data['timeStamp'],
      pushTime: data['pushTime'],
      actionType: actionTypeFromString(data['actionType']),
    );
  }

  static String actionTypeToString(ActionType actionType) {
    return describeEnum(actionType);
  }

  static ActionType actionTypeFromString(String actionType) {
    ActionType.values.forEach((element) {
      if (describeEnum(element) == actionType) {
        return element;
      }
    });
    return ActionType.ALL;
  }

  static bool requiresLocation(ActionType type) {
    return !(type.toString().contains("OTHER"));
  }
}

enum ActionType {
  ALL,
  TEST,
  FOUL_REG,
  FOUL_TECH,
  FOUL_YELLOW,
  FOUL_RED,
  FOUL_DISABLED,
  FOUL_DISQUAL,
  SHOT_LOW,
  SHOT_OUTER,
  SHOT_INNER,
  INTAKE,
  MISSED_LOW,
  MISSED_OUTER,
  MISSED_INTAKE,
  OTHER_CLIMB,
  OTHER_CLIMB_MISS,
  OTHER_WHEEL_POSITION,
  OTHER_WHEEL_ROTATION,
  PREV_SHOT,
  PREV_INTAKE,
  PUSH_START,
  PUSH_END,
  OTHER_CROSSED_INITIATION_LINE,
  OTHER_PARKED,
  OTHER_LEVELLED,
}
