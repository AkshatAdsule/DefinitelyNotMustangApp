// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'dart:math';
import '../../backend/game_action.dart';
import '../../components/game_map.dart';
import '../../components/game_buttons.dart' as game_button;
import 'dart:async';

// ignore: must_be_immutable
class OffenseScouting extends StatefulWidget {
  void Function() _toggleMode;
  void Function(ActionType type, BuildContext context) _addAction;
  void Function(int millisecondsElapsed) _setClimb;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;
  String _allianceColor;
  bool _completedRotationControl;
  bool _completedPositionControl;
  bool _crossedInitiationLine;

  OffenseScouting(
      {void Function() toggleMode,
      void Function(int millisecondsElapsed) setClimb,
      void Function(ActionType type, BuildContext context) addAction,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid,
      String allianceColor,
      bool completedRotationControl,
      bool completedPositionControl,
      bool crossedInitiationLine}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
    _setClimb = setClimb;
    _allianceColor = allianceColor;
    _completedRotationControl = completedRotationControl;
    _completedPositionControl = completedPositionControl;
    _crossedInitiationLine = crossedInitiationLine;
  }

  void setRotationControl(bool completed) =>
      _completedRotationControl = completed;

  void setPositionControl(bool completed) =>
      _completedRotationControl = completed;

  void setInitiationLine(bool crossed) => _completedRotationControl = crossed;

  @override
  _OffenseScoutingState createState() => _OffenseScoutingState(
        toggleMode: _toggleMode,
        stopwatch: _stopwatch,
        zoneGrid: _zoneGrid,
        addAction: _addAction,
        setClimb: _setClimb,
        allianceColor: _allianceColor,
        completedRotationControl: _completedRotationControl,
        completedPositionControl: _completedPositionControl,
        crossedInitiationLine: _crossedInitiationLine,
      );
}

class _OffenseScoutingState extends State<OffenseScouting> {
  void Function() _toggleMode;
  void Function(int millisecondsElapsed) _setClimb;
  void Function(ActionType type, BuildContext context) _addAction;

  Stopwatch _stopwatch;
  String _allianceColor;
  double _sliderValue;
  bool _completedRotationControl,
      _completedPositionControl,
      _crossedInitiationLine;
  Timer _endgameTimer, _endTimer, _teleopTimer;
  ZoneGrid _zoneGrid;

  _OffenseScoutingState({
    void Function() toggleMode,
    void Function(int millisecondsElapsed) setClimb,
    void Function(ActionType type, BuildContext context) addAction,
    Stopwatch stopwatch,
    ZoneGrid zoneGrid,
    String allianceColor,
    bool completedRotationControl,
    bool completedPositionControl,
    bool crossedInitiationLine,
  }) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
    _setClimb = setClimb;
    _allianceColor = allianceColor;
    _completedRotationControl = completedRotationControl;
    _completedPositionControl = completedPositionControl;
    _crossedInitiationLine = crossedInitiationLine;
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = 2;
    _completedRotationControl = false;
    _completedPositionControl = false;
    _crossedInitiationLine = false;

    if (_stopwatch.elapsedMilliseconds <= 120000) {
      _endgameTimer = new Timer(
          Duration(milliseconds: 120000 - _stopwatch.elapsedMilliseconds), () {
        setState(() {});
      });
    }
    if (_stopwatch.elapsedMilliseconds <= 150000) {
      _endTimer = new Timer(
          Duration(milliseconds: 150000 - _stopwatch.elapsedMilliseconds), () {
        setState(() {});
      });
    }
    if (_stopwatch.elapsedMilliseconds <= 15000) {
      _teleopTimer = new Timer(
          Duration(milliseconds: 15000 - _stopwatch.elapsedMilliseconds), () {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _endTimer.cancel();
    _endgameTimer.cancel();
    _teleopTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GameMap(
        allianceColor: _allianceColor,
        zoneGrid: _zoneGrid,
        imageChildren: [
          _completedRotationControl && _completedPositionControl
              ? Container()
              : GameMapChild(
                  right: 65,
                  bottom: 17.5,
                  align: Alignment(-0.14, 0.73),
                  child: CircleAvatar(
                    backgroundColor:
                        !_completedRotationControl ? Colors.green : Colors.blue,
                    child: IconButton(
                      onPressed: () {
                        if (!_completedRotationControl) {
                          _addAction(ActionType.OTHER_WHEEL_ROTATION, context);
                          setState(() {
                            _completedRotationControl = true;
                          });
                        } else {
                          _addAction(ActionType.OTHER_WHEEL_POSITION, context);
                          setState(() {
                            _completedPositionControl = true;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.donut_large,
                        color: Colors.white,
                      ),
                    ),
                  )),
          _stopwatch.elapsedMilliseconds >= 120000
              ? GameMapChild(
                  align: Alignment(-0.07, -0.17),
                  child: Transform.rotate(
                    angle: -pi / 8,
                    child: Container(
                      height: 30,
                      width: 200,
                      child: Slider(
                        divisions: 2,
                        label: _sliderValue.round().toString(),
                        onChanged: (newVal) => setState(() {
                          _sliderValue = newVal;
                          _setClimb(_stopwatch.elapsedMilliseconds);
                        }),
                        min: 1,
                        max: 3,
                        value: _sliderValue,
                      ),
                    ),
                  ),
                )
              : Container(),
          (_stopwatch.elapsedMilliseconds <= 15000 && !_crossedInitiationLine)
              ? GameMapChild(
                  align: Alignment(0, 0),
                  child: CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.check, color: Colors.white),
                      color: Colors.green,
                      onPressed: () {
                        _addAction(
                            ActionType.OTHER_CROSSED_INITIATION_LINE, context);
                        // setState(() {
                        _crossedInitiationLine = true;
                        // });
                      },
                    ),
                  ),
                )
              : Container(),
        ],
        sideWidget: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.TOGGLE,
                    onPressed: _toggleMode,
                    text: 'Defense'),
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
              ),
              Flexible(
                flex: 1,
                child: game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      _addAction(ActionType.MISSED_OUTER, context);
                    },
                    text: ''),
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
                        text: '')
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
                        text: '')
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
