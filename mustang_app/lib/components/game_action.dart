enum ActionType {FOUL_REG, FOUL_TECH, FOUL_YELLOW, FOUL_RED, FOUL_DISABLED, FOUL_DISQUAL,
                SHOT_LOW, SHOT_OUTER, SHOT_INNER, MISSED_LOW, MISSED_OUTER,
                OTHER_CLIMB, OTHER_CLIMB_MISS, OTHER_WHEEL_POSITION, OTHER_WHEEL_COLOR,
                PREV_SHOT, PREV_INTAKE, PUSH}
class GameAction{
  //end row, end column, push time are only for push, will be null most of time
  double seconds_elapsed, x, y, end_x, end_y, push_time;
  ActionType action;
  GameAction(this.action, this.seconds_elapsed, this.x, this.y, );
  GameAction.push(this.seconds_elapsed, this.x, this.y, this.end_x, this.end_y, this.push_time){
    action = ActionType.PUSH;
  }

}