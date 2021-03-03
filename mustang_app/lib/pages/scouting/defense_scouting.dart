import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import '../../components/game_map.dart';
import '../../components/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScouting extends StatefulWidget {
  void Function(ActionType type, BuildContext context) _addAction;
  void Function() _toggleMode;

  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;
  String _allianceColor;

  DefenseScouting(
      {Key key,
      void Function() toggleMode,
      void Function(ActionType type, BuildContext context) addAction,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid,
      String allianceColor})
      : super(key: key) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
    _allianceColor = allianceColor;
  }

  @override
  _DefenseScoutingState createState() => _DefenseScoutingState(
      toggleMode: _toggleMode,
      stopwatch: _stopwatch,
      zoneGrid: _zoneGrid,
      addAction: _addAction,
      allianceColor: _allianceColor);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode;

  int Function(ActionType type, BuildContext context) _addAction;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;
  Timer _endTimer;
  String _allianceColor;
  bool _pushTextStart = false;
  var _prev = [0, 0];

  _DefenseScoutingState({
    void Function() toggleMode,
    void Function(ActionType type, BuildContext context) addAction,
    Stopwatch stopwatch,
    ZoneGrid zoneGrid,
    String allianceColor,
  }) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
    _allianceColor = allianceColor;
  }

  @override
  void initState() {
    super.initState();
    if (_stopwatch.elapsedMilliseconds <= 120000) {
      _endTimer = new Timer(
          Duration(milliseconds: 150000 - _stopwatch.elapsedMilliseconds),
          () => setState(() {}));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _endTimer.cancel();
  }

  void actionDeterminer(BuildContext context, String action) {
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
          _addAction(
              GameAction.stringToActionType(
                  action.toUpperCase() + "_" + type.toUpperCase()),
              context);
          Navigator.pop(context);
        },
      );
      optionButtons.add(option);
    }
    // set up the AlertDialog
    AlertDialog popUp = AlertDialog(
      title: Text(action),
      content: Text('type'),
      actions: optionButtons,
    );

    // show the dialog
    showDialog(
      builder: (context) => popUp, routeSettings: RouteSettings(arguments: ScreenOrientation.landscapeOnly),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GameMap(
        allianceColor: _allianceColor,
        zoneGrid: _zoneGrid,
        imageChildren: [],
        sideWidget: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.TOGGLE,
                      onPressed: _toggleMode,
                      text: 'Offense',
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {
                        if (_addAction(ActionType.PREV_INTAKE, context) == 0)
                          setState(() {
                            _prev[0]++;
                            _prev[1] = 0;
                          });
                      },
                      text: 'Prevent Intake',
                    ),
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.FLAT,
                        type: game_button.ButtonType.COUNTER,
                        onPressed: () {},
                        text: _prev[0].toString()),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {
                        if (_addAction(ActionType.PREV_INTAKE, context) == 0)
                          setState(() {
                            _prev[1]++;
                            _prev[0] = 0;
                          });
                      },
                      text: 'Prevent Shot',
                    ),
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.FLAT,
                        type: game_button.ButtonType.COUNTER,
                        onPressed: () {},
                        text: _prev[1].toString()),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {
                        if (_pushTextStart) {
                          if (_addAction(ActionType.PUSH_END, context) != -1)
                            setState(() {
                              _pushTextStart = false;
                            });
                        } else {
                          if (_addAction(ActionType.PUSH_START, context) != -1)
                            setState(() {
                              _pushTextStart = true;
                            });
                        }
                        _prev.clear();
                      },
                      text: !_pushTextStart ? "Push Start" : "Push End",
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.ELEMENT,
                      onPressed: () {
                        actionDeterminer(context, 'Foul');
                        _prev.clear();
                      },
                      text: 'Foul',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
