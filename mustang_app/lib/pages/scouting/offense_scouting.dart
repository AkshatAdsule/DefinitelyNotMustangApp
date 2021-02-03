import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'dart:math';
import '../../components/game_action.dart';
import '../../components/game_map.dart';
import '../../components/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class OffenseScouting extends StatefulWidget {
  void Function() _toggleMode, _undo;
  void Function(BuildContext context) _finishGame;
  void Function(ActionType type) _addAction;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;

  OffenseScouting({
    Key key,
    void Function() toggleMode,
    void Function() undo,
    void Function(BuildContext context) finishGame,
    void Function(ActionType type) addAction,
    Stopwatch stopwatch,
    ZoneGrid zoneGrid,
  })  : _toggleMode = toggleMode,
        _stopwatch = stopwatch,
        _finishGame = finishGame,
        _zoneGrid = zoneGrid,
        _addAction = addAction,
        _undo = undo,
        super(key: key);

  @override
  _OffenseScoutingState createState() => _OffenseScoutingState(
      toggleMode: _toggleMode,
      finishGame: _finishGame,
      stopwatch: _stopwatch,
      zoneGrid: _zoneGrid,
      addAction: _addAction,
      undo: _undo);
}

class _OffenseScoutingState extends State<OffenseScouting> {
  void Function() _toggleMode, _undo;
  void Function(BuildContext context) _finishGame;
  void Function(ActionType type) _addAction;

  Stopwatch _stopwatch;

  double _sliderValue;
  bool _completedRotationControl, _completedPositionControl;

  ZoneGrid _zoneGrid;

  _OffenseScoutingState(
      {void Function() toggleMode,
      void Function() undo,
      void Function(BuildContext context) finishGame,
      void Function(ActionType type) addAction,
      Stopwatch stopwatch,
      ZoneGrid zoneGrid}) {
    _toggleMode = toggleMode;
    _finishGame = finishGame;
    _stopwatch = stopwatch;
    _zoneGrid = zoneGrid;
    _addAction = addAction;
    _undo = undo;
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = 2;
    _completedRotationControl = false;
    _completedPositionControl = false;
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
                onPressed: () => _undo(),
              ),
            ),
          ),
          _completedRotationControl && _completedPositionControl
              ? Container()
              : GameMapChild(
                  right: 65,
                  bottom: 17.5,
                  align: Alignment.bottomCenter,
                  child: CircleAvatar(
                    backgroundColor:
                        !_completedRotationControl ? Colors.green : Colors.blue,
                    child: IconButton(
                      onPressed: () {
                        if (_completedRotationControl) {
                          _addAction(ActionType.OTHER_WHEEL_ROTATION);
                          setState(() {
                            _completedRotationControl = true;
                          });
                        } else {
                          _addAction(ActionType.OTHER_WHEEL_POSITION);
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
          _stopwatch.elapsedMilliseconds > 120000
              ? GameMapChild(
                  right: 30,
                  bottom: 55,
                  align: Alignment.center,
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
                        }),
                        min: 1,
                        max: 3,
                        value: _sliderValue,
                      ),
                    ),
                  ),
                )
              : Container(),
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
              : Container(),
        ],
        sideWidgets: [
          Expanded(
            child: Column(children: [
              game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.TOGGLE,
                  onPressed: _toggleMode,
                  text: 'Defense'),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/goal_cropped.jpg'),
                        fit: BoxFit.fitHeight),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MAKE,
                              onPressed: () {
                                _addAction(ActionType.SHOT_OUTER);
                              },
                              text: 'Out'),
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MAKE,
                              onPressed: () {
                                _addAction(ActionType.SHOT_INNER);
                              },
                              text: 'In'),
                        ],
                      ),
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MISS,
                          onPressed: () {
                            _addAction(ActionType.MISSED_OUTER);
                          },
                          text: ''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MAKE,
                              onPressed: () {
                                _addAction(ActionType.SHOT_LOW);
                              },
                              text: 'Low'),
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MISS,
                              onPressed: () {
                                _addAction(ActionType.MISSED_LOW);
                              },
                              text: '')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
