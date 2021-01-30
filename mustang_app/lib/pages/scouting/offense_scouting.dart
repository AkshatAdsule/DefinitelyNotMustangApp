import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/exports/pages.dart';
import 'dart:math';
import '../../components/game_action.dart';
import '../../components/game_map.dart';
import '../../components/game_buttons.dart' as game_button;

class OffenseScouting extends StatefulWidget {
  void Function() _toggleMode;
  Stopwatch _stopwatch;

  OffenseScouting({void Function() toggleMode, Stopwatch stopwatch}) {
    _toggleMode = toggleMode;
    _stopwatch = stopwatch;
  }

  @override
  _OffenseScoutingState createState() =>
      _OffenseScoutingState(toggleMode: _toggleMode, stopwatch: _stopwatch);
}

class _OffenseScoutingState extends State<OffenseScouting> {
  void Function() _toggleMode, _endGame;
  Stopwatch _stopwatch;

  double _sliderValue = 2;

  List<GameAction> shots = new List<GameAction>();

  _OffenseScoutingState(
      {void Function() toggleMode,
      void Function() endGame,
      Stopwatch stopwatch}) {
    _toggleMode = toggleMode;
    _endGame = endGame;
    _stopwatch = stopwatch;
  }

  // /*
  void addAction(ActionType type) {
    int now = _stopwatch.elapsedMilliseconds;
    // MapLocation newLoc = new MapLocation();
    int x = ZoneGrid.x; //x location
    int y = ZoneGrid.y; //y location
    GameAction action =
        new GameAction(type, now.toDouble(), x.toDouble(), y.toDouble());
    shots.add(action);
    print(action);
  }

  // */
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GameMap(
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
                onPressed: () {
                  addAction(ActionType.OTHER_WHEEL_COLOR);
                },
              ),
            ),
          ),
          GameMapChild(
              right: 65,
              bottom: 17.5,
              align: Alignment.bottomCenter,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.donut_large,
                    color: Colors.white,
                  ),
                ),
              )),
          GameMapChild(
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
          ),
          GameMapChild(
              align: Alignment.topLeft,
              left: 7,
              top: 7,
              child: game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.PAGEBUTTON,
                  onPressed: _endGame,
                  text: 'End Game')),
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
                                addAction(ActionType.SHOT_OUTER);
                              },
                              text: 'Out'),
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MAKE,
                              onPressed: () {
                                addAction(ActionType.SHOT_INNER);
                              },
                              text: 'In'),
                        ],
                      ),
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MISS,
                          onPressed: () {
                            addAction(ActionType.MISSED_OUTER);
                          },
                          text: ''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MAKE,
                              onPressed: () {
                                addAction(ActionType.SHOT_LOW);
                              },
                              text: 'Low'),
                          game_button.ScoutingButton(
                              style: game_button.ButtonStyle.RAISED,
                              type: game_button.ButtonType.MISS,
                              onPressed: () {
                                addAction(ActionType.MISSED_LOW);
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
