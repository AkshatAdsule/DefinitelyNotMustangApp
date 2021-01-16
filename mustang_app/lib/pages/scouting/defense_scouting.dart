import 'package:flutter/material.dart';
import '../../components/game_map.dart';

import '../../components/game_buttons.dart' as game_button;

class DefenseScouting extends StatefulWidget {
  void Function() _toggleMode;

  DefenseScouting({void Function() toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _DefenseScoutingState createState() =>
      _DefenseScoutingState(toggleMode: _toggleMode);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode;

  _DefenseScoutingState({void Function() toggleMode}) {
    _toggleMode = toggleMode;
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
          )
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
