import 'package:flutter/material.dart';
import '../../components/game_map.dart';

class DefenseScouting extends StatefulWidget {
  void Function() _toggleMode;

  DefenseScouting({void Function() toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _DefenseScoutingState createState() =>
      _DefenseScoutingState(toggleMode: _toggleMode);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  void Function() _toggleMode;

  _DefenseScoutingState({void Function() toggleMode}) {
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
                    child: Text('Offense'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Prevent Shot'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Prevent Intake'),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Push'),
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
