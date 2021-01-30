import 'package:flutter/material.dart';
import '../../components/game_map.dart';

import '../../components/game_buttons.dart' as game_button;

class DefenseScouting extends StatefulWidget {
  void Function() _toggleMode, _finishGame;
  Stopwatch _stopwatch;

  DefenseScouting(
      {void Function() toggleMode,
      void Function() finishGame,
      Stopwatch stopwatch}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _finishGame = finishGame;
  }

  @override
  _DefenseScoutingState createState() => _DefenseScoutingState(
      toggleMode: _toggleMode, finishGame: _finishGame, stopwatch: _stopwatch);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode, _finishGame;
  Stopwatch _stopwatch;

  _DefenseScoutingState(
      {void Function() toggleMode,
      void Function() finishGame,
      Stopwatch stopwatch}) {
    _toggleMode = toggleMode;
    stopwatch = _stopwatch;
    _finishGame = finishGame;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GameMap(
        imageChildren: [
          GameMapChild(
            align: Alignment.bottomLeft,
            left: 7,
            bottom: 7,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                icon: Icon(Icons.undo),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
          _stopwatch.elapsedMilliseconds > 150000
              ? GameMapChild(
                  align: Alignment.topLeft,
                  left: 7,
                  top: 7,
                  child: game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.PAGEBUTTON,
                      onPressed: _finishGame,
                      text: 'Finish Game'))
              : Container()
        ],
        sideWidgets: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.TOGGLE,
                      onPressed: _toggleMode,
                      text: 'Offense'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {},
                      text: 'Prevent Intake'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {},
                      text: 'Push'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {},
                      text: 'Foul'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
