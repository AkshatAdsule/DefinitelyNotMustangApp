import 'package:flutter/material.dart';
import 'dart:math';
import '../../components/game_map.dart';
import '../../components/buttons.dart' as theme;

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
        withGoal: true,
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
            // child: Image(image: Image.asset('assets/goal.jpg'),),
            child: Container(
              // decoration: BoxDecoration(// TODO: fix to make it actually showing
              //   image: DecorationImage(
              //     image: AssetImage('assets/goal.jpg'),
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  theme.TextButton(
                      style: theme.ButtonStyle.RAISED,
                      type: theme.ButtonType.TOGGLE,
                      onPressed: _toggleMode,
                      text: 'Defense'),
                  theme.TextButton(
                      style: theme.ButtonStyle.RAISED,
                      type: theme.ButtonType.MAKE,
                      onPressed: null,
                      id: '@in',
                      text: 'In'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      theme.TextButton(
                          style: theme.ButtonStyle.RAISED,
                          type: theme.ButtonType.MAKE,
                          onPressed: null,
                          id: '@out_make',
                          text: 'Out'),
                      theme.TextButton(
                          style: theme.ButtonStyle.RAISED,
                          type: theme.ButtonType.MISS,
                          onPressed: null,
                          id: '@out_miss',
                          text: ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      theme.TextButton(
                          style: theme.ButtonStyle.RAISED,
                          type: theme.ButtonType.MAKE,
                          onPressed: null,
                          id: '@low_make',
                          text: 'Low'),
                      theme.TextButton(
                          style: theme.ButtonStyle.RAISED,
                          type: theme.ButtonType.MISS,
                          onPressed: null,
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
