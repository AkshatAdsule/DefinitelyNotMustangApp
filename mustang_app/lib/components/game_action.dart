class GameAction {
  //end row, end column, push time are only for push, will be null most of time
  double _timeStamp, _x, _y, _endX, _endY, _pushTime;
  ActionType _action;
  GameAction(
    this._action,
    this._timeStamp,
    this._x,
    this._y,
  );
  //for push, timeStamp is at the beginning of the push
  GameAction.push(this._timeStamp, _x, _y, _endX, _endY, _pushTime) {
    _action = ActionType.PUSH;
  }

  Map<String, dynamic> toJson() {
    return {
      'timeStamp': _timeStamp,
      'x': _x,
      'y': _y,
      'endX': _endX,
      'endY': _endY,
      'pushTime': _pushTime,
      'actionType': _action.toString(),
    };
  }

  GameAction.fromJson(Map<String, dynamic> data) {
    _x = data['x'];
    _y = data['y'];
    _timeStamp = data['timeStamp'];
    _endX = data['endX'];
    _endY = data['endY'];
    _pushTime = data['pushTime'];
    _action = ActionType.values
        .firstWhere((element) => element.toString() == data['actionType']);
  }
}

enum ActionType {
  FOUL_REG,
  FOUL_TECH,
  FOUL_YELLOW,
  FOUL_RED,
  FOUL_DISABLED,
  FOUL_DISQUAL,
  SHOT_LOW,
  SHOT_OUTER,
  SHOT_INNER,
  MISSED_LOW,
  MISSED_OUTER,
  OTHER_CLIMB,
  OTHER_CLIMB_MISS,
  OTHER_WHEEL_POSITION,
  OTHER_WHEEL_COLOR,
  PREV_SHOT,
  PREV_INTAKE,
  PUSH
}
