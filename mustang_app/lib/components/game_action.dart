class GameAction {
  //end row, end column, push time are only for push, will be null most of time
  double _secondsElapsed, _x, _y, _endX, _endY, _pushTime;
  ActionType _action;
  GameAction(
    this._action,
    this._secondsElapsed,
    this._x,
    this._y,
  );
  GameAction.push(this._secondsElapsed, _x, _y, _endX, _endY, _pushTime) {
    _action = ActionType.PUSH;
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
