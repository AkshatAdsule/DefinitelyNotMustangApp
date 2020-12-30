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
              align: Alignment.center,
              child: RaisedButton(
                onPressed: () {},
                child: Text('This is offense'),
              ))
        ],
        columnChildren: [
          RaisedButton(
            onPressed: _toggleMode,
            child: Text('Toggle Mode'),
          )
        ],
      ),
    );
  }
}
