import 'dart:async';
import 'package:mustang_app/components/PathPainter.dart';
import 'package:mustang_app/components/climb_scouting_overlay.dart';
import 'package:mustang_app/components/climb_scouting_side.dart';
import 'package:mustang_app/components/defense_scouting_overlay.dart';
import 'package:mustang_app/components/offense_scouting_overlay.dart';
import 'package:mustang_app/components/stopwatch_display.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/defense_scouting_side.dart';
import 'package:mustang_app/components/game_map.dart';
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

class _MapScoutingState extends State<MapScouting>
// with SingleTickerProviderStateMixin
{
  AnimationController _controller;
  bool _pushMode, _startedScouting;
  Stopwatch _stopwatch;
  String _teamNumber, _matchNumber, _allianceColor;
  Color _bgColor = Colors.blueGrey.shade300;

  bool _offenseOnRightSide;
  ZoneGrid _zoneGrid;

  List<GameAction> _actions;
  int _sliderLastChanged;
  bool _completedRotationControl,
      _completedPositionControl,
      _crossedInitiationLine;
  double _sliderVal;
  int _counter = 0;
  bool _pushTextStart;
  Timer _endgameTimer, _endTimer, _teleopTimer;
  int _prevX = -1, _prevY = -1, _pushStartX = -1, _pushStartY = -1;
  List<bool> _toggleModes = [true, false, false];

  _MapScoutingState(
    this._teamNumber,
    this._matchNumber,
    this._allianceColor,
    this._offenseOnRightSide,
  );

  @override
  void initState() {
    super.initState();
    // _controller = new AnimationController(
    //     vsync: this,
    //   duration: Duration(milliseconds: 1000),
    // );
    _pushMode = false;
    _startedScouting = false;
    _stopwatch = new Stopwatch();
    _zoneGrid = SelectableZoneGrid(
      GlobalKey(),
      (int x, int y) {
        if (x != _prevX || y != _prevY) {
          setState(() {
            _prevX = x;
            _prevY = y;
            _counter = 0;
          });
        }
        // if (_pushTextStart) {
        //   _startAnimation();
        // }
      },
      type: AnimationType.TRANSLATE,
      multiSelect: true,
      createOverlay: (BoxConstraints constraints, List<Offset> selections,
          double cellWidth, double cellHeight) {
        if (selections.length == 0) {
          return [];
        }
        if (_pushTextStart) {
          return [
            ...(selections.length > 1
                ? [
                    CustomPaint(
                      painter: PathPainter([
                        Offset(
                          cellWidth * _pushStartX + cellWidth / 2,
                          cellHeight * _pushStartY + cellHeight / 2,
                        ),
                        Offset(
                          cellWidth * selections.last.dx + cellWidth / 2,
                          cellHeight * selections.last.dy + cellHeight / 2,
                        ),
                      ], animation: _controller),
                    ),
                    AnimatedPositioned(
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 1000),
                      left: cellWidth * _pushStartX,
                      top: cellHeight * _pushStartY,
                      child: Container(
                        width: cellWidth,
                        height: cellHeight,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.lightGreenAccent.withOpacity(0.9),
                                  Colors.green,
                                ],
                              ),
                            ),
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                  ]
                : []),
            AnimatedPositioned(
              child: Container(
                width: cellWidth,
                height: cellHeight,
                child: Image.asset('assets/bb8.gif'),
              ),
              left: cellWidth * selections.last.dx,
              top: cellHeight * selections.last.dy,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 1000),
            ),
          ];
        } else {
          return [
            AnimatedPositioned(
              child: Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   gradient: RadialGradient(
                //     colors: [
                //       Colors.green,
                //       Colors.green, //.withOpacity(0.9),
                //       Colors.lightGreenAccent.withOpacity(0.9),
                //     ],
                //   ),
                // ),
                width: cellWidth,
                height: cellHeight,
                child: Image.asset('assets/bb8.gif'),
              ),
              left: cellWidth * selections.last.dx,
              top: cellHeight * selections.last.dy,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 1000),
            )
          ];
        }
      },
    );
    _completedRotationControl = false;
    _completedPositionControl = false;
    _crossedInitiationLine = false;
    _actions = [];
    _counter = 0;
    _pushTextStart = false;
    _sliderLastChanged = 0;
    _sliderVal = 2;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();

    if (_endTimer != null) {
      _endTimer.cancel();
    }
    if (_endgameTimer != null) {
      _endgameTimer.cancel();
    }
    if (_teleopTimer != null) {
      _teleopTimer.cancel();
    }

    if (_stopwatch != null && _stopwatch.isRunning) _stopwatch.stop();
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward();
  }

  void _initTimers() {
    if (_stopwatch.elapsedMilliseconds <= Constants.endgameStartMillis) {
      _endgameTimer = new Timer(
          Duration(milliseconds: Constants.endgameStartMillis),
          () => setState(() {
                _bgColor = Colors.red.shade300;
              }));
    }
    if (_stopwatch.elapsedMilliseconds <= Constants.matchEndMillis) {
      _endTimer = new Timer(
          Duration(milliseconds: Constants.matchEndMillis),
          () => setState(() {
                _bgColor = Colors.white;
              }));
    }
    if (_stopwatch.elapsedMilliseconds <= Constants.teleopStartMillis) {
      _teleopTimer = new Timer(
          Duration(milliseconds: Constants.teleopStartMillis),
          () => setState(() {
                _bgColor = Colors.orange.shade300;
              }));
    }
  }

  void _setPush() {
    setState(() {
      if (!_pushTextStart) {
        _zoneGrid.clearSelections();
        _pushStartX = _zoneGrid.x;
        _pushStartY = _zoneGrid.y;
      }
      _pushTextStart = !_pushTextStart;
    });
  }

  void _setCounter(int newCount) {
    setState(() {
      _counter = newCount;
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
    _updateCounter(action);
    _vibrate();
    return true;
  }

  Future<void> _vibrate() async {
    if (Constants.enableVibrations && await Vibration.hasVibrator()) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        if (await Vibration.hasAmplitudeControl()) {
          Vibration.vibrate(
            amplitude: 60,
            duration: 100,
          );
        } else {
          Vibration.vibrate(
            duration: 100,
          );
        }
      } else {
        if (await Vibration.hasAmplitudeControl()) {
          Vibration.vibrate(amplitude: 60);
        } else {
          Vibration.vibrate();
        }
      }
    }
  }

  void _updateCounter(GameAction action) {
    String type = action.action.toString();
    if (type.contains("SHOT") ||
        type.contains("MISSED") ||
        type.contains("INTAKE") ||
        type.contains("PREV")) {
      setState(() {
        _counter++;
      });
    } else {
      setState(() {
        _counter = 0;
      });
    }
  }

  void _setClimb(double newVal) {
    setState(() {
      _sliderVal = newVal;
      _sliderLastChanged = _stopwatch.elapsedMilliseconds;
    });
  }

  void _addClimb(ActionType actionType) {
    _actions.removeWhere((element) {
      String type = element.action.toString();
      return type.contains("PARKED") ||
          type.contains("CLIMB") ||
          type.contains("LEVELLED");
    });

    _actions.add(
      GameAction(
        actionType,
        _sliderLastChanged.toDouble() ?? Constants.endgameStartMillis,
        actionType == ActionType.OTHER_CLIMB_MISS ? _zoneGrid.x : _sliderVal,
        actionType == ActionType.OTHER_CLIMB_MISS ? _zoneGrid.y : _sliderVal,
      ),
    );
  }

  void _setCrossedInitiationLine(bool newVal) {
    setState(() {
      _crossedInitiationLine = newVal;
    });
  }

  void _finishGame(BuildContext context) {
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
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      }
      return action;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingOverlay = Container(
      child: IndexedStack(
        index: _toggleModes.indexOf(true),
        children: [
          OffenseScoutingOverlay(
            addAction: _addAction,
            stopwatch: _stopwatch,
            completedPositionControl: _completedPositionControl,
            completedRotationControl: _completedRotationControl,
            crossedInitiationLine: _crossedInitiationLine,
            onWheelPress: _onWheelPress,
            setClimb: _setClimb,
            setCrossedInitiationLine: _setCrossedInitiationLine,
          ),
          DefenseScoutingOverlay(
            addAction: _addAction,
            stopwatch: _stopwatch,
          ),
          ClimbScoutingOverlay(
            addAction: _addAction,
            stopwatch: _stopwatch,
            setClimb: _setClimb,
            sliderValue: _sliderVal,
          ),
        ],
      ),
    );

    Widget scoutingSide = Container(
      child: IndexedStack(
        index: _toggleModes.indexOf(true),
        children: [
          OffenseScoutingSide(
            addAction: _addAction,
          ),
          DefenseScoutingSide(
            addAction: _addAction,
            pushTextStart: _pushTextStart,
            setPush: _setPush,
          ),
          ClimbScoutingSide(
            addAction: _addAction,
            setClimb: _setClimb,
            addClimb: _addClimb,
          ),
        ],
      ),
    );

    return Screen(
      title: 'Map Scouting',
      headerButtons: [
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: _startedScouting ? StopwatchDisplay() : Container(),
        ),
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: game_button.ScoutingButton(
              style: game_button.ButtonStyle.FLAT,
              type: game_button.ButtonType.COUNTER,
              onPressed: () {},
              text: "Counter: " + (_counter ?? 0).toString()),
        ),
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
          color: _bgColor,
          child: BlurOverlay(
            unlocked: _startedScouting,
            background: GameMap(
              stopwatch: _stopwatch,
              allianceColor: _allianceColor,
              offenseOnRightSide: _offenseOnRightSide,
              zoneGrid: _zoneGrid,
              imageChildren: [scoutingOverlay],
              sideWidget: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ModeToggle(
                        onPressed: (int ind) {
                          setState(() {
                            List<bool> newToggle = List.generate(
                                _toggleModes.length, (index) => index == ind);
                            _toggleModes = newToggle;
                          });
                        },
                        isSelected: _toggleModes,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: scoutingSide,
                    ),
                  ],
                ),
              ),
            ),
            text: Text('Start'),
            onEnd: () {
              setState(
                () {
                  _startedScouting = true;
                  _stopwatch.start();
                  _initTimers();
                },
              );
            },
          )),
    );
  }
}

// ignore: must_be_immutable
class CounterText extends StatelessWidget {
  int _counter;

  CounterText(this._counter);

  @override
  Widget build(BuildContext context) {
    return game_button.ScoutingButton(
        style: game_button.ButtonStyle.FLAT,
        type: game_button.ButtonType.COUNTER,
        onPressed: () {},
        text: "Counter: " + _counter.toString());
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
      text: "UNDO",
    );
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
            ),
          )
        : Container();
  }
}

class ModeToggle extends StatelessWidget {
  void Function(int) onPressed;
  List<bool> isSelected;
  List<Widget> children;
  Key key;
  ModeToggle({this.children, this.onPressed, this.isSelected, this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ToggleButtons(
        key: key,
        children: [
          Icon(
            Icons.gps_fixed,
            color: isSelected[0] ? Colors.white : Colors.green,
          ),
          Icon(
            Icons.shield,
            color: isSelected[1] ? Colors.white : Colors.green,
          ),
          Icon(
            Icons.precision_manufacturing_sharp,
            color: isSelected[2] ? Colors.white : Colors.green,
          ),
        ],
        onPressed: (int val) {
          onPressed(val);
        },
        isSelected: isSelected,
        selectedColor: Colors.green,
        renderBorder: true,
        direction: Axis.horizontal,
        borderRadius: BorderRadius.circular(30),
        borderColor: Colors.green,
        borderWidth: 3,
        selectedBorderColor: Colors.green,
        fillColor: Colors.green,
      ),
    );
  }
}
