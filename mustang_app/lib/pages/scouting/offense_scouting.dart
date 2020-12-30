import 'package:flutter/material.dart';
import 'dart:math';
import '../../components/game_map.dart';

class OffenseScouting extends StatefulWidget {
  void Function() _toggleMode;

  OffenseScouting({void Function() toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _OffenseScoutingState createState() =>
      _OffenseScoutingState(toggleMode: _toggleMode);
}

class _OffenseScoutingState extends State<OffenseScouting> {
  void Function() _toggleMode;
  double _sliderValue = 2;

  _OffenseScoutingState({void Function() toggleMode}) {
    _toggleMode = toggleMode;
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
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: _toggleMode,
                    child: Text('Defense'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Inner'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Outer'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Miss'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Bottom'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Miss'),
                      ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Foul'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
