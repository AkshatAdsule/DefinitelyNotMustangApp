import 'package:flutter/material.dart';
import '../../components/game_map.dart';

class OffenseScouting extends StatefulWidget {
  Function _toggleMode;

  OffenseScouting({Function toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _OffenseScoutingState createState() =>
      _OffenseScoutingState(toggleMode: _toggleMode);
}

class _OffenseScoutingState extends State<OffenseScouting> {
  Function _toggleMode;

  _OffenseScoutingState({Function toggleMode}) {
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
                onPressed: () {
                  print('yi');
                },
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
