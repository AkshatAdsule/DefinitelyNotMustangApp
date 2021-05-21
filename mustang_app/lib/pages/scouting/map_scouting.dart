import 'dart:async';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/constants/preferences.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/components/map_scouting/animated_push_line.dart';
import 'package:mustang_app/components/map_scouting/climb_scouting_overlay.dart';
import 'package:mustang_app/components/map_scouting/climb_scouting_side.dart';
import 'package:mustang_app/components/map_scouting/defense_scouting_overlay.dart';
import 'package:mustang_app/components/inputs/mode_toggle.dart';
import 'package:mustang_app/components/map_scouting/offense_scouting_overlay.dart';
import 'package:mustang_app/components/shared/map/scouting_zone_grid.dart';
import 'package:mustang_app/components/utils/stopwatch_display.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/map_scouting/blur_overlay.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/components/map_scouting/defense_scouting_side.dart';
import 'package:mustang_app/components/shared/map/game_map.dart';
import 'package:mustang_app/components/map_scouting/offense_scouting_side.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import '../../components/inputs/game_buttons.dart' as game_button;
import 'match_end_scouting.dart';

// ignore: must_be_immutable
class MapScouting extends StatefulWidget {
  static const String route = '/MapScouter';
  String _teamNumber, _matchNumber, _allianceColor;
  bool _offenseOnRightSide;
  GlobalKey<MapScoutingState> _key;
  MatchType _matchType;

  MapScouting({
    GlobalKey<MapScoutingState> key,
    String teamNumber,
    String matchNumber,
    String allianceColor,
    bool offenseOnRightSide,
    MatchType matchType,
  }) : super(key: key) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _allianceColor = allianceColor;
    _offenseOnRightSide = offenseOnRightSide;
    _key = key;
    _matchType = matchType;
  }

  @override
  MapScoutingState createState() => MapScoutingState(_key, _teamNumber,
      _matchNumber, _allianceColor, _offenseOnRightSide, _matchType);
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
  MatchType _matchType;
  final GlobalKey stopwatchKey = GlobalKey();
  GlobalKey<MapScoutingState> mapScoutingKey;
  final GlobalKey<ZoneGridState> zoneGridKey = GlobalKey<ZoneGridState>();
  final GlobalKey<AnimatedPushLineState> pushLineKey =
      GlobalKey<AnimatedPushLineState>();

  MapScoutingState(this.mapScoutingKey, this.teamNumber, this.matchNumber,
      this.allianceColor, this.offenseOnRightSide, this._matchType);

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
    if (stopwatch.elapsedMilliseconds <= GameConstants.endgameStartMillis) {
      _endgameTimer = new Timer(
          Duration(milliseconds: GameConstants.endgameStartMillis),
          () => setState(() {
                _bgColor = Colors.red.shade300;
              }));
    }
    if (stopwatch.elapsedMilliseconds <= GameConstants.matchEndMillis) {
      _endTimer = new Timer(
          Duration(milliseconds: GameConstants.matchEndMillis),
          () => setState(() {
                _bgColor = Colors.white;
              }));
    }
    if (stopwatch.elapsedMilliseconds <= GameConstants.teleopStartMillis) {
      _teleopTimer = new Timer(
          Duration(milliseconds: GameConstants.teleopStartMillis),
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
    if (Preferences.enableVibrations && await Vibration.hasVibrator()) {
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
        sliderLastChanged.toDouble() ?? GameConstants.endgameStartMillis,
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
      'matchType': _matchType,
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

  void onZoneGridTap(int x, int y) {
    setState(() {
      prevX = x;
      prevY = y;
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Map Scouting',
      color: _bgColor,
      key: UniqueKey(),
      includeBottomNav: false,
      headerButtons: [
        Container(
          margin: EdgeInsets.only(
            right: 10,
          ),
          child: startedScouting
              ? StopwatchDisplay(
                  key: stopwatchKey,
                )
              : Container(),
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
      child: MultiProvider(
        providers: [
          Provider(
            create: (BuildContext context) => zoneGridKey,
          ),
          Provider(
            create: (BuildContext context) => mapScoutingKey,
          ),
          Provider(
            create: (BuildContext context) => pushLineKey,
          ),
        ],
        child: Container(
          child: BlurOverlay(
            unlocked: startedScouting,
            background: GameMap(
              stopwatch: stopwatch,
              allianceColor: allianceColor,
              offenseOnRightSide: offenseOnRightSide,
              zoneGrid: ScoutingZoneGrid(
                zoneGridKey: zoneGridKey,
                mapScoutingKey: mapScoutingKey,
                pushLineKey: pushLineKey,
              ),
              imageChildren: [
                Container(
                  child: IndexedStack(
                    index: toggleModes.indexOf(true),
                    children: [
                      OffenseScoutingOverlay(),
                      DefenseScoutingOverlay(),
                      ClimbScoutingOverlay(),
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
                        isDisabled: pushTextStart,
                        isSelected: toggleModes,
                        direction: Axis.horizontal,
                        children: [
                          ModeToggleChild(
                            icon: Icons.gps_fixed,
                            isSelected: toggleModes[0],
                          ),
                          ModeToggleChild(
                            icon: Icons.shield,
                            isSelected: toggleModes[1],
                          ),
                          ModeToggleChild(
                            icon: Icons.precision_manufacturing_sharp,
                            isSelected: toggleModes[2],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: IndexedStack(
                          index: toggleModes.indexOf(true),
                          children: [
                            OffenseScoutingSide(),
                            DefenseScoutingSide(),
                            ClimbScoutingSide(),
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
    return stopwatch.elapsedMilliseconds >= GameConstants.matchEndMillis
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
