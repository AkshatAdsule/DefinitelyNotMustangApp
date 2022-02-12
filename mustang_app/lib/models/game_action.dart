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
      this.pushTime = 0.0});

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
      x: data['x'].toDouble(),
      y: data['y'].toDouble(),
      timeStamp: data['timeStamp'].toDouble(),
      pushTime: data['pushTime'].toDouble(),
      actionType: actionTypeFromString(data['actionType']),
    );
  }

  static String actionTypeToString(ActionType actionType) {
    return describeEnum(actionType);
  }

  static ActionType actionTypeFromString(String actionType) {
    ActionType ret;
    ActionType.values.forEach((element) {
      if (describeEnum(element) == actionType) {
        ret = element;
      }
    });
    return ret ?? ActionType.ALL;
  }

  static bool requiresLocation(ActionType type) {
    return !(type.toString().contains("OTHER"));
  }
}

enum  ActionType {
  SHOT_INNER,
  MISSED_INNER,
  SHOT_OUTER,
  MISSED_OUTER,
  SHOT_LOW,
  MISSED_LOW,
  INTAKE,
  MISSED_INTAKE,
  //Rapid React Actions
  SHOT_UPPER,
  SHOT_LOWER,
  MISSED_UPPER,
  MISSED_LOWER,
  GROUND_INTAKE,
  MISSED_GROUND_INTAKE,
  TERMINAL_INTAKE,
  MISSED_TERMINAL_INTAKE,
  STEPH_CURRY_SHOOTS,

  //climb actions
  LOW_RUNG_CLIMB,
  MID_RUNG_CLIMB,
  HIGH_RUNG_CLIMB,
  TRAVERSAL_RUNG_CLIMB,

  OTHER_WHEEL_ROTATION,
  OTHER_WHEEL_POSITION,
  PREV_SHOT,
  PREV_INTAKE,
  PUSH_START,
  PUSH_END,
  OTHER_PARKED,
  OTHER_CLIMB,
  OTHER_CLIMB_MISS,
  OTHER_LEVELLED,
  OTHER_CROSSED_INITIATION_LINE,
  FOUL_REG,
  FOUL_TECH,
  FOUL_YELLOW,
  FOUL_RED,
  FOUL_DISABLED,
  FOUL_DISQUAL,
  ALL,
  TEST,
}
