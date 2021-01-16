import 'package:flutter/material.dart';
import 'dart:math';
import '../../components/game_map.dart';
import '../../components/game_buttons.dart' as game_button;

class OffenseScouting extends StatefulWidget {
  void Function() _toggleMode;

  OffenseScouting({void Function() toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _OffenseScoutingState createState() =>
      _OffenseScoutingState(toggleMode: _toggleMode);
}

class Action {
  int timeStamp;
  String buttonId;
  Action({this.timeStamp, this.buttonId});
}

class _OffenseScoutingState extends State<OffenseScouting> {
  void Function() _toggleMode;
  double _sliderValue = 2;

  List<Action> shots = new List<Action>();

  _OffenseScoutingState({void Function() toggleMode}) {
    _toggleMode = toggleMode;
  }

// TODO: make addAction() get called everytime element-of-game button is clicked,
// to keep track of all actions
  void addAction(String id) {
    int now = 111; //TODO: change this to acutal time
    shots.add(new Action(timeStamp: now, buttonId: id));
  }

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
                onPressed: () {},
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
        ],
        sideWidgets: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/goal.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.TOGGLE,
                      onPressed: _toggleMode,
                      text: 'Defense'),
                  game_button.ScoutingButton(
                      style: game_button.ButtonStyle.RAISED,
                      type: game_button.ButtonType.MAKE,
                      onPressed: () {},
                      id: '@in',
                      text: 'In'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MAKE,
                          onPressed: () {},
                          id: '@out_make',
                          text: 'Out'),
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MISS,
                          onPressed: () {},
                          id: '@out_miss',
                          text: ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MAKE,
                          onPressed: () {},
                          id: '@low_make',
                          text: 'Low'),
                      game_button.ScoutingButton(
                          style: game_button.ButtonStyle.RAISED,
                          type: game_button.ButtonType.MISS,
                          onPressed: () {},
                          id: '@low_miss',
                          text: '')
                    ],
                  ),
                  // theme.TextButton(
                  //   style: theme.ButtonStyle.RAISED,
                  //   type: theme.ButtonType.ELEMENT,
                  //   onPressed: null,
                  //   text: 'Foul'
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
