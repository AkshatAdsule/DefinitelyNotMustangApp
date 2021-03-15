class GameAction {
  //end row, end column, push time are only for push, will be null most of time
  double _timeStamp, _x, _y, _pushTime;
  ActionType _action;
  GameAction(
    this._action,
    this._timeStamp,
    this._x,
    this._y,
  );

  GameAction.other(this._action, this._timeStamp) {
    _x = -1;
    _y = -1;
  }

  //for push, timeStamp is at the beginning of the push
  //GameAction.push(this._action, this._timeStamp, this._x, this._y, this._endX,
  //    this._endY, this._pushTime);
  //_action = ActionType.PUSH;

  String toString() {
    return "Type: " +
        _action.toString() +
        "; Duration: " +
        _timeStamp.toString() +
        "; Location: (" +
        _x.toString() +
        ", " +
        _y.toString() +
        ")";
  }

  double get timeStamp => _timeStamp;
  double get x => _x;
  double get y => _y;
  double get pushTime => _pushTime;
  ActionType get action => _action;

  set x(double x) => _x = x;
  set y(double y) => _y = y;
  set pushTime(double pushTime) => _pushTime = pushTime;
  set action(ActionType action) => _action = action;

  Map<String, dynamic> toJson() {
    return {
      'timeStamp': _timeStamp,
      'x': _x,
      'y': _y,
      'pushTime': _pushTime,
      'actionType': _action.toString(),
    };
  }

  GameAction.fromJson(Map<String, dynamic> data) {
    _x = data['x'];
    _y = data['y'];
    _timeStamp = data['timeStamp'];
    _pushTime = data['pushTime'];
    _action = ActionType.values
        .firstWhere((element) => element.toString() == data['actionType']);
  }

  static ActionType stringToActionType(String str) {
    ActionType action = ActionType.values
        .firstWhere((e) => e.toString() == 'ActionType.' + str);
    return action;
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
