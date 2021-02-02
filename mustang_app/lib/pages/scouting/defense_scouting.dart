import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';
import 'package:mustang_app/components/selectable_zone_grid.dart';
import 'package:mustang_app/components/zone_grid.dart';
import '../../components/game_map.dart';

import '../../components/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScouting extends StatefulWidget {
  void Function() _toggleMode, _finishGame;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;

  DefenseScouting(
      {void Function() toggleMode,
      void Function() finishGame,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _finishGame = finishGame;
    _zoneGrid = zoneGrid;
  }

  @override
  _DefenseScoutingState createState() => _DefenseScoutingState(
      toggleMode: _toggleMode,
      finishGame: _finishGame,
      stopwatch: _stopwatch,
      zoneGrid: _zoneGrid);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode, _finishGame;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;
  List<GameAction> def = new List<GameAction>();

  _DefenseScoutingState(
      {void Function() toggleMode,
      void Function() finishGame,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _finishGame = finishGame;
    _zoneGrid = zoneGrid;
  }

// TODO: move addAction() to map scouting
  void addAction(ActionType type) {
    int now = _stopwatch.elapsedMilliseconds;
    int x = _zoneGrid.x;
    int y = _zoneGrid.y;
    bool hasSelected = _zoneGrid.hasSelected;
    if (hasSelected) {
      GameAction action =
          new GameAction(type, now.toDouble(), x.toDouble(), y.toDouble());
      def.add(action);
      print(action);
    } else {
      print('No location selected');
    }
  }

  ActionType labelAction(String action) {
    // TODO: Add long switch for all types
    print(action);
    return ActionType.TEST;
  }

  ActionType actionDeterminer(BuildContext context, String action) {
    List<String> types = new List<String>();
    List<FlatButton> optionButtons = new List<FlatButton>();

    switch (action) {
      case 'Foul':
        types = ['Reg', 'Tech', 'Red', 'Yellow', 'Disabled', 'Disqual'];
        break;
      case 'Wheel':
        types = ['Rotate', 'Color'];
        break;
      case 'Climb':
        types = ['Make', 'Miss'];
        break;
    }

    for (String type in types) {
      FlatButton option = FlatButton(
        child: Text(type),
        onPressed: () {
          labelAction(action + "_" + type);
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
    print("Defense: " +
        _zoneGrid.hasSelected.toString() +
        " " +
        _zoneGrid.x.toString() +
        " " +
        _zoneGrid.y.toString());

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
                      onPressed: () {
                        // actionDeterminer(context, 'Foul');
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
