import 'package:flutter/material.dart';
import '../backend/game_action.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class OffenseScoutingSide extends StatelessWidget {
  bool Function(ActionType type, BuildContext context) _addAction;
  Widget _toggleMode;

  OffenseScoutingSide({
    bool Function(ActionType type, BuildContext context) addAction,
    Widget toggleMode,
  }) {
    _toggleMode = toggleMode;
    _addAction = addAction;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flexible(
          //   flex: 1,
          //   child: _toggleMode,
          // ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.RAISED,
                        type: game_button.ButtonType.MAKE,
                        onPressed: () {
                          _addAction(ActionType.SHOT_OUTER, context);
                        },
                        text: 'Out'),
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.RAISED,
                        type: game_button.ButtonType.MAKE,
                        onPressed: () {
                          _addAction(ActionType.SHOT_INNER, context);
                        },
                        text: 'In'),
                  ],
                ),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      _addAction(ActionType.MISSED_OUTER, context);
                    },
                    text: 'Miss'),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MAKE,
                    onPressed: () {
                      _addAction(ActionType.SHOT_LOW, context);
                    },
                    text: 'Low'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      _addAction(ActionType.MISSED_LOW, context);
                    },
                    text: 'Miss')
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MAKE,
                    onPressed: () {
                      _addAction(ActionType.INTAKE, context);
                    },
                    text: 'Intake'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      _addAction(ActionType.MISSED_INTAKE, context);
                    },
                    text: 'Miss')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
