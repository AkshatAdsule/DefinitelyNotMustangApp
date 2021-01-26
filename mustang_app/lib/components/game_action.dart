enum ActionType {FOUL_REG, FOUL_TECH, FOUL_YELLOW, FOUL_RED, FOUL_DISABLED, FOUL_DISQUAL,
                SHOT_LOW, SHOT_OUTER, SHOT_INNER, MISSED_LOW, MISSED_OUTER,
                OTHER_CLIMB, OTHER_CLIMB_MISS, OTHER_WHEEL_POSITION, OTHER_WHEEL_COLOR,
                PREV_SHOT, PREV_INTAKE, PUSH}
class GameAction{
  //end row, end column, push time are only for push, will be null most of time
  double seconds_elapsed, column, row, end_column, end_row, push_time;
  ActionType action;
  GameAction.normal(this.action, this.seconds_elapsed, this.column, this.row, );
  GameAction.push(this.seconds_elapsed, this.column, this.row, this.end_column, this.end_row, this.push_time){
    action = ActionType.PUSH;
  }

}