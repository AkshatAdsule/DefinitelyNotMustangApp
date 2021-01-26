enum ActionType {FOUL_REG, FOUL_TECH, FOUL_YELLOW, FOUL_RED, FOUL_DISABLED, FOUL_DISQUAL,
                SHOT_LOW, SHOT_OUTER, SHOT_INNER, MISSED_LOW, MISSED_OUTER,
                OTHER_CLIMB, OTHER_CLIMB_MISS, OTHER_WHEEL_POSITION, OTHER_WHEEL_COLOR,
                PREV_SHOT, PREV_INTAKE, PUSH}
class GameAction{
  //end row, end column, push time are only for push
  double seconds_elapsed, row, column, end_row, end_column, push_time;
  ActionType action;
  GameAction.normal(this.action, this.seconds_elapsed, this.row, this.column);
  GameAction.push(this.action, this.seconds_elapsed, this.row, this.column, this.end_row, this.end_column, this.push_time);

}