import 'package:flutter/material.dart';
import '../../components/game_map.dart';

class DefenseScouting extends StatefulWidget {
  Function _toggleMode;

  DefenseScouting({Function toggleMode}) {
    _toggleMode = toggleMode;
  }

  @override
  _DefenseScoutingState createState() =>
      _DefenseScoutingState(toggleMode: _toggleMode);
}

class _DefenseScoutingState extends State<DefenseScouting> {
  Function _toggleMode;

  _DefenseScoutingState({Function toggleMode}) {
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
                child: Text('This is Defense'),
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
