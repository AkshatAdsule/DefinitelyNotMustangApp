import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/defense_scouting_overlay.dart';
import 'package:mustang_app/components/defense_scouting_side.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/offense_scouting_overlay.dart';
import 'package:mustang_app/components/offense_scouting_side.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/components/selectable_zone_grid.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/exports/pages.dart';
import '../../components/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class MapScouting extends StatefulWidget {
  static const String route = '/MapScouter';
  String _teamNumber, _matchNumber, _allianceColor;
  bool _offenseOnRightSide;

  MapScouting(
      {String teamNumber,
      String matchNumber,
      String allianceColor,
      bool offenseOnRightSide}) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _allianceColor = allianceColor;
    _offenseOnRightSide = offenseOnRightSide;
  }

  @override
  _MapScoutingState createState() => _MapScoutingState(
      _teamNumber, _matchNumber, _allianceColor, _offenseOnRightSide);
}

class _MapScoutingState extends State<MapScouting> {
  bool _onOffense, _startedScouting;
  Stopwatch _stopwatch;
  String _teamNumber, _matchNumber, _allianceColor;
  bool _offenseOnRightSide;
  ZoneGrid _zoneGrid;
  List<GameAction> _actions;
  int _sliderLastChanged;
  bool _completedRotationControl,
      _completedPositionControl,
      _crossedInitiationLine;
  double _sliderVal;
  List<int> _prev;
  bool _pushTextStart;
  Timer _endgameTimer, _endTimer, _teleopTimer;

  _MapScoutingState(this._teamNumber, this._matchNumber, this._allianceColor,
      this._offenseOnRightSide);

  @override
  void initState() {
    super.initState();
    _onOffense = true;
    _startedScouting = false;
    _stopwatch = new Stopwatch();
    _zoneGrid = SelectableZoneGrid(UniqueKey(), (int x, int y) {});
    _completedRotationControl = false;
    _completedPositionControl = false;
    _crossedInitiationLine = false;
    _actions = [];
    _prev = [0, 0];
    _pushTextStart = false;
    _sliderLastChanged = 0;
    _sliderVal = 2;
  }

  @override
  void dispose() {
    super.dispose();
    _endTimer.cancel();
    _endgameTimer.cancel();
    _teleopTimer.cancel();
    _stopwatch.stop();
  }

  void _initTimers() {
    if (_stopwatch.elapsedMilliseconds <= Constants.endgameStartMillis) {
      _endgameTimer = new Timer(
          Duration(milliseconds: Constants.endgameStartMillis),
          () => setState(() {}));
    }
    if (_stopwatch.elapsedMilliseconds <= Constants.matchEndMillis) {
      _endTimer = new Timer(Duration(milliseconds: Constants.matchEndMillis),
          () => setState(() {}));
    }
    if (_stopwatch.elapsedMilliseconds <= Constants.teleopStartMillis) {
      _teleopTimer = new Timer(
          Duration(milliseconds: Constants.teleopStartMillis),
          () => setState(() {}));
    }
  }

  void _toggleMode() {
    setState(() {
      _onOffense = !_onOffense;
    });
  }

  void _setPrev(List<int> newPrev) {
    setState(() {
      _prev = newPrev;
    });
  }

  void _setPush(bool newVal) {
    setState(() {
      _pushTextStart = newVal;
    });
  }

  void _onWheelPress() {
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
  }

  // -1 = no loc, 0 = all good
  bool _addAction(ActionType type, BuildContext context) {
    int now = _stopwatch.elapsedMilliseconds;
    int x = _zoneGrid.x;
    int y = _zoneGrid.y;
    bool hasSelected = _zoneGrid.hasSelected;
    GameAction action;
    if (hasSelected && GameAction.requiresLocation(type)) {
      action = new GameAction(type, now.toDouble(), x.toDouble(), y.toDouble());
    } else if (!GameAction.requiresLocation(type)) {
      action = GameAction.other(type, now.toDouble());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No location selected"),
        duration: Duration(milliseconds: 1500),
      ));
      return false;
    }
    _actions.add(action);
    return true;
  }

  void _setClimb(double newVal) {
    setState(() {
      _sliderVal = newVal;
      _sliderLastChanged = _stopwatch.elapsedMilliseconds;
    });
  }

  void _setCrossedInitiationLine(bool newVal) {
    setState(() {
      _crossedInitiationLine = newVal;
    });
  }

  void _finishGame(BuildContext context) {
    _actions.add(
      GameAction(
        ActionType.OTHER_CLIMB,
        _sliderLastChanged.toDouble() ?? Constants.endgameStartMillis,
        _sliderVal,
        _sliderVal,
      ),
    );
    Navigator.pushNamed(context, MatchEndScouter.route, arguments: {
      'teamNumber': _teamNumber,
      'matchNumber': _matchNumber,
      'actions': _actions,
      'allianceColor': _allianceColor,
      'offenseOnRightSide': _offenseOnRightSide,
      'climbLocation': _sliderVal,
    });
  }

  GameAction _undo() {
    if (_actions.length > 0) {
      GameAction action = _actions.removeLast();
      switch (action.action) {
        case ActionType.OTHER_WHEEL_ROTATION:
          setState(() {
            _completedRotationControl = false;
          });
          break;
        case ActionType.OTHER_WHEEL_POSITION:
          setState(() {
            _completedPositionControl = false;
          });
          break;
        case ActionType.OTHER_CROSSED_INITIATION_LINE:
          setState(() {
            _crossedInitiationLine = false;
          });
          break;
        default:
          break;
      }
      return action;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingOverlay = IndexedStack(
      index: _onOffense ? 0 : 1,
      children: [
        OffenseScoutingOverlay(
          addAction: _addAction,
          stopwatch: _stopwatch,
          completedPositionControl: _completedPositionControl,
          completedRotationControl: _completedRotationControl,
          crossedInitiationLine: _crossedInitiationLine,
          onWheelPress: _onWheelPress,
          setClimb: _setClimb,
          sliderValue: _sliderVal,
          setCrossedInitiationLine: _setCrossedInitiationLine,
        ),
        DefenseScoutingOverlay(
          stopwatch: _stopwatch,
          addAction: _addAction,
        ),
      ],
    );
    Widget scoutingSide = IndexedStack(
      index: _onOffense ? 0 : 1,
      children: [
        OffenseScoutingSide(
          addAction: _addAction,
          toggleMode: _toggleMode,
        ),
        DefenseScoutingSide(
          addAction: _addAction,
          toggleMode: _toggleMode,
          prev: _prev,
          setPrev: _setPrev,
          pushTextStart: _pushTextStart,
          setPush: _setPush,
        ),
      ],
    );

    return Screen(
      title: 'Map Scouting',
      headerButtons: [
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: UndoButton(_undo),
        ),
        FinishGameButton(
          () => _finishGame(context),
          _stopwatch,
        )
      ],
      includeBottomNav: false,
      child: Container(
        child: !_startedScouting
            ? BlurOverlay(
                background: GameMap(
                  allianceColor: _allianceColor,
                  offenseOnRightSide: _offenseOnRightSide,
                  zoneGrid: _zoneGrid,
                  imageChildren: [scoutingOverlay],
                  sideWidget: scoutingSide,
                ),
                text: Text('Start'),
                onEnd: () {
                  setState(() {
                    _startedScouting = true;
                    _stopwatch.start();
                    _initTimers();
                  });
                },
              )
            : GameMap(
                allianceColor: _allianceColor,
                offenseOnRightSide: _offenseOnRightSide,
                zoneGrid: _zoneGrid,
                imageChildren: [scoutingOverlay],
                sideWidget: scoutingSide,
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UndoButton extends StatelessWidget {
  void Function() _onClick;

  UndoButton(this._onClick);

  @override
  Widget build(BuildContext context) {
    return game_button.ScoutingButton(
        style: game_button.ButtonStyle.RAISED,
        type: game_button.ButtonType.PAGEBUTTON,
        onPressed: _onClick,
        text: "UNDO");
  }
}

// ignore: must_be_immutable
class FinishGameButton extends StatelessWidget {
  void Function() _onClick;
  Stopwatch _stopwatch;
  FinishGameButton(this._onClick, this._stopwatch);

  @override
  Widget build(BuildContext context) {
    return _stopwatch.elapsedMilliseconds >= Constants.matchEndMillis
        ? Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: game_button.ScoutingButton(
              style: game_button.ButtonStyle.RAISED,
              type: game_button.ButtonType.ELEMENT,
              onPressed: () => _onClick(),
              text: 'Finish Game',
            ))
        : Container();
  }
}
