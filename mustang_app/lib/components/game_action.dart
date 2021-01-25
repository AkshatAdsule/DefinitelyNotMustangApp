enum ActionType {FOUL_REG, FOUL_TECH, FOUL_YELLOW}

/*foul_reg, foul_tech, foul_yellow, foul_red, foul_disabled, foul_disqual,
    shot_low, shot_outer, shot_inner, missed_low, missed_outer, 
    other_climb, other_climb_miss, other_wheel_position, other_wheel_color, 
    prev_shot, prev_intake, push}*/

class GameAction{
  double seconds_elapsed, row, column, end_row, end_column, push_time;
  //String actionType;
  ActionType action;
  GameAction(this.action, this.seconds_elapsed, this.row, this.column);
  //Action.normalAction(this.action, this.seconds_elapsed, this.row, this.column);
  //Action.pushAction(this.action, this.seconds_elapsed, this.row, this.column, this.end_row, this.end_column, this.push_time);
}