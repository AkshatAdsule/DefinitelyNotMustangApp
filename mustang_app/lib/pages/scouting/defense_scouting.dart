import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';
import 'package:mustang_app/components/zone_grid.dart';
import '../../components/game_map.dart';

import '../../components/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScouting extends StatefulWidget {
  void Function(BuildContext context) _finishGame;
  void Function(ActionType type) _addAction;

  void Function() _toggleMode;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;

  DefenseScouting(
      {void Function() toggleMode,
      void Function(BuildContext context) finishGame,
      void Function(ActionType type) addAction,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _finishGame = finishGame;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
  }

  @override
  _DefenseScoutingState createState() => _DefenseScoutingState(
      toggleMode: _toggleMode,
      finishGame: _finishGame,
      stopwatch: _stopwatch,
      zoneGrid: _zoneGrid,
      addAction: _addAction);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode;
  void Function(BuildContext context) _finishGame;
  void Function(ActionType type) _addAction;

  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;
  List<GameAction> _actions = new List<GameAction>();

  _DefenseScoutingState(
      {void Function() toggleMode,
      void Function(BuildContext context) finishGame,
      void Function(ActionType type) addAction,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _finishGame = finishGame;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
  }

  ActionType actionDeterminer(BuildContext context, String action) {
    List<String> types = [
      'Reg',
      'Tech',
      'Red',
      'Yellow',
      'Disabled',
      'Disqual'
    ];
    List<FlatButton> optionButtons = new List<FlatButton>();

    for (String type in types) {
      FlatButton option = FlatButton(
        child: Text(type),
        onPressed: () {
          addAction(GameAction.labelAction(
              action.toUpperCase() + "_" + type.toUpperCase()));
          Navigator.pop(context);
        },
      );
      optionButtons.add(option);
    }

    // set up the AlertDialog
    AlertDialog popUp = AlertDialog(
      title: Text(action),
      actions: optionButtons,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return popUp;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GameMap(
        zoneGrid: _zoneGrid,
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
                      onPressed: () => _finishGame(context),
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
                      onPressed: () {
                        addAction(ActionType.PREV_INTAKE);
                      },
                      text: 'Prevent Intake'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {},
                      text: 'Push'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {
                        actionDeterminer(context, 'Foul');
                      },
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
