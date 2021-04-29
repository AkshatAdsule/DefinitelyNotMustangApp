import 'dart:async';
import 'package:mustang_app/components/climb_scouting_overlay.dart';
import 'package:mustang_app/components/climb_scouting_side.dart';
import 'package:mustang_app/components/default_zone_grid_overlay.dart';
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
  GlobalKey<MapScoutingState> _key;

  MapScouting({
    GlobalKey<MapScoutingState> key,
    String teamNumber,
    String matchNumber,
    String allianceColor,
    bool offenseOnRightSide,
  }) : super(key: key) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _allianceColor = allianceColor;
    _offenseOnRightSide = offenseOnRightSide;
    _key = key;
  }

  @override
  MapScoutingState createState() => MapScoutingState(
        _key,
        _teamNumber,
        _matchNumber,
        _allianceColor,
        _offenseOnRightSide,
      );
}

class MapScoutingState extends State<MapScouting> {
  bool startedScouting;
  Stopwatch stopwatch;
  String teamNumber, matchNumber, allianceColor;
  Color _bgColor = Colors.blueGrey.shade300;
  bool offenseOnRightSide;
  List<GameAction> actions;
  int sliderLastChanged;
  bool completedRotationControl,
      completedPositionControl,
      crossedInitiationLine;
  double sliderVal;
  int counter = 0;
  bool pushTextStart;
  Timer _endgameTimer, _endTimer, _teleopTimer;
  int prevX = -1, prevY = -1, pushStartX = -1, pushStartY = -1;
  List<bool> toggleModes = [true, false, false];

  GlobalKey<MapScoutingState> mapScoutingKey;
  final GlobalKey<ZoneGridState> zoneGridKey = GlobalKey<ZoneGridState>();
  final GlobalKey<AnimatedPushLineState> pushLineKey =
      GlobalKey<AnimatedPushLineState>();

  MapScoutingState(
    this.mapScoutingKey,
    this.teamNumber,
    this.matchNumber,
    this.allianceColor,
    this.offenseOnRightSide,
  );

  @override
  void initState() {
    super.initState();
    startedScouting = false;
    stopwatch = new Stopwatch();
    completedRotationControl = false;
    completedPositionControl = false;
    crossedInitiationLine = false;
    actions = [];
    counter = 0;
    pushTextStart = false;
    sliderLastChanged = 0;
    sliderVal = 2;
  }

  @override
  void dispose() {
    super.dispose();

    if (_endTimer != null) {
      _endTimer.cancel();
    }
    if (_endgameTimer != null) {
      _endgameTimer.cancel();
    }
    if (_teleopTimer != null) {
      _teleopTimer.cancel();
    }

    if (stopwatch != null && stopwatch.isRunning) stopwatch.stop();
  }

  void _initTimers() {
    if (stopwatch.elapsedMilliseconds <= Constants.endgameStartMillis) {
      _endgameTimer = new Timer(
          Duration(milliseconds: Constants.endgameStartMillis),
          () => setState(() {
                _bgColor = Colors.red.shade300;
              }));
    }
    if (stopwatch.elapsedMilliseconds <= Constants.matchEndMillis) {
      _endTimer = new Timer(
          Duration(milliseconds: Constants.matchEndMillis),
          () => setState(() {
                _bgColor = Colors.white;
              }));
    }
    if (stopwatch.elapsedMilliseconds <= Constants.teleopStartMillis) {
      _teleopTimer = new Timer(
          Duration(milliseconds: Constants.teleopStartMillis),
          () => setState(() {
                _bgColor = Colors.orange.shade300;
              }));
    }
  }

  void setPush() {
    setState(() {
      if (!pushTextStart) {
        zoneGridKey.currentState.clearSelections();
        pushStartX = zoneGridKey.currentState.x;
        pushStartY = zoneGridKey.currentState.y;
      }
      pushTextStart = !pushTextStart;
    });
  }

  void onWheelPress() {
    if (!completedRotationControl) {
      addAction(ActionType.OTHER_WHEEL_ROTATION, context);
      setState(() {
        completedRotationControl = true;
      });
    } else {
      addAction(ActionType.OTHER_WHEEL_POSITION, context);
      setState(() {
        completedPositionControl = true;
      });
    }
  }

  bool addAction(ActionType type, BuildContext context) {
    int now = stopwatch.elapsedMilliseconds;
    int x = zoneGridKey.currentState.x;
    int y = zoneGridKey.currentState.y;
    bool hasSelected = zoneGridKey.currentState.hasSelected;
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
    actions.add(action);
    updateCounter(action);
    vibrate();
    return true;
  }

  Future<void> vibrate() async {
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

  void updateCounter(GameAction action) {
    String type = action.action.toString();
    if (type.contains("SHOT") ||
        type.contains("MISSED") ||
        type.contains("INTAKE") ||
        type.contains("PREV")) {
      setState(() {
        counter++;
      });
    } else {
      setState(() {
        counter = 0;
      });
    }
  }

  void setClimb(double newVal) {
    setState(() {
      sliderVal = newVal;
      sliderLastChanged = stopwatch.elapsedMilliseconds;
    });
  }

  void addClimb(ActionType actionType) {
    actions.removeWhere((element) {
      String type = element.action.toString();
      return type.contains("PARKED") ||
          type.contains("CLIMB") ||
          type.contains("LEVELLED");
    });

    actions.add(
      GameAction(
        actionType,
        sliderLastChanged.toDouble() ?? Constants.endgameStartMillis,
        actionType == ActionType.OTHER_CLIMB_MISS
            ? zoneGridKey.currentState.x
            : sliderVal,
        actionType == ActionType.OTHER_CLIMB_MISS
            ? zoneGridKey.currentState.y
            : sliderVal,
      ),
    );
    vibrate();
  }

  void setCrossedInitiationLine(bool newVal) {
    setState(() {
      crossedInitiationLine = newVal;
    });
  }

  void _finishGame(BuildContext context) {
    Navigator.pushNamed(context, MatchEndScouter.route, arguments: {
      'teamNumber': teamNumber,
      'matchNumber': matchNumber,
      'actions': actions,
      'allianceColor': allianceColor,
      'offenseOnRightSide': offenseOnRightSide,
      'climbLocation': sliderVal,
    });
  }

  GameAction _undo() {
    if (actions.length > 0) {
      GameAction action = actions.removeLast();
      switch (action.action) {
        case ActionType.OTHER_WHEEL_ROTATION:
          setState(() {
            completedRotationControl = false;
          });
          break;
        case ActionType.OTHER_WHEEL_POSITION:
          setState(() {
            completedPositionControl = false;
          });
          break;
        case ActionType.OTHER_CROSSED_INITIATION_LINE:
          setState(() {
            crossedInitiationLine = false;
          });
          break;
        default:
          break;
      }
      if (counter > 0) {
        setState(() {
          counter--;
        });
      }
      return action;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Map Scouting',
      includeBottomNav: false,
      headerButtons: [
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: startedScouting ? StopwatchDisplay() : Container(),
        ),
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: game_button.ScoutingButton(
              style: game_button.ButtonStyle.FLAT,
              type: game_button.ButtonType.COUNTER,
              onPressed: () {},
              text: "Counter: " + (counter ?? 0).toString()),
        ),
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: UndoButton(_undo),
        ),
        FinishGameButton(
          () => _finishGame(context),
          stopwatch,
        )
      ],
      child: Container(
        color: _bgColor,
        child: BlurOverlay(
          unlocked: startedScouting,
          background: GameMap(
            stopwatch: stopwatch,
            allianceColor: allianceColor,
            offenseOnRightSide: offenseOnRightSide,
            zoneGrid: SelectableZoneGrid(
              zoneGridKey,
              (int x, int y) {
                if (x != prevX || y != prevY) {
                  setState(() {
                    prevX = x;
                    prevY = y;
                    counter = 0;
                  });
                }
                if (pushTextStart) {
                  zoneGridKey.currentState.clearSelections();
                  pushLineKey.currentState.startAnimation();
                }
              },
              type: AnimationType.TRANSLATE,
              multiSelect: true,
              createOverlay: (BoxConstraints constraints,
                      List<Offset> selections,
                      double cellWidth,
                      double cellHeight) =>
                  defaultOverlay(
                constraints,
                selections,
                cellWidth,
                cellHeight,
                zoneGridKey,
                mapScoutingKey,
                pushLineKey,
              ),
            ),
            imageChildren: [
              Container(
                child: IndexedStack(
                  index: toggleModes.indexOf(true),
                  children: [
                    OffenseScoutingOverlay(
                      mapScoutingKey: mapScoutingKey,
                      zoneGridKey: zoneGridKey,
                    ),
                    DefenseScoutingOverlay(
                      mapScoutingKey: mapScoutingKey,
                      zoneGridKey: zoneGridKey,
                    ),
                    ClimbScoutingOverlay(
                      mapScoutingKey: mapScoutingKey,
                      zoneGridKey: zoneGridKey,
                    ),
                  ],
                ),
              )
            ],
            sideWidget: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ModeToggle(
                      onPressed: (int ind) {
                        setState(
                          () {
                            List<bool> newToggle = List.generate(
                                toggleModes.length, (index) => index == ind);
                            toggleModes = newToggle;
                          },
                        );
                      },
                      isSelected: toggleModes,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: IndexedStack(
                        index: toggleModes.indexOf(true),
                        children: [
                          OffenseScoutingSide(
                            mapScoutingKey: mapScoutingKey,
                            zoneGridKey: zoneGridKey,
                          ),
                          DefenseScoutingSide(
                            mapScoutingKey: mapScoutingKey,
                            zoneGridKey: zoneGridKey,
                          ),
                          ClimbScoutingSide(
                            mapScoutingKey: mapScoutingKey,
                            zoneGridKey: zoneGridKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          text: Text('Start'),
          onEnd: () {
            setState(
              () {
                startedScouting = true;
                stopwatch.start();
                _initTimers();
              },
            );
          },
        ),
      ),
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
  Stopwatch stopwatch;
  FinishGameButton(this._onClick, this.stopwatch);

  @override
  Widget build(BuildContext context) {
    return stopwatch.elapsedMilliseconds >= Constants.matchEndMillis
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
