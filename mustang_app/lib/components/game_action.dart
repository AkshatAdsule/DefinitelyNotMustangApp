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
  GameAction.push(this._action, this._timeStamp, this._x, this._y, this._endX,
      this._endY, this._pushTime);
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
  double get endX => _endX;
  double get endY => _endY;
  double get pushTime => _pushTime;
  ActionType get action => _action;

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

  static ActionType labelAction(String str) {
    print("preLabel:" + str);
    ActionType action = ActionType.values
        .firstWhere((e) => e.toString() == 'ActionType.' + str);
    print(action.toString());
    return action;
  }
}

enum ActionType {
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
  MISSED_LOW,
  MISSED_OUTER,
  OTHER_CLIMB,
  OTHER_CLIMB_MISS,
  OTHER_WHEEL_POSITION,
  OTHER_WHEEL_COLOR,
  PREV_SHOT,
  PREV_INTAKE,
  PUSH,
}
