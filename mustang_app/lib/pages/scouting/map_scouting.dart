import 'package:flutter/material.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import 'package:mustang_app/exports/pages.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/header.dart';
import 'defense_scouting.dart';
import 'offense_scouting.dart';

class MapScouting extends StatefulWidget {
  static const String route = '/MapScouter';
  String _teamNumber, _matchNumber;

  MapScouting({String teamNumber, String matchNumber}) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
  }

  @override
  _MapScoutingState createState() =>
      _MapScoutingState(_teamNumber, _matchNumber);
}

class _MapScoutingState extends State<MapScouting> {
  bool _onOffense, _startedScouting, _stopGame;
  Stopwatch _stopwatch;
  String _teamNumber, _matchNumber;

  _MapScoutingState(String teamNumber, String matchNumber) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
  }

  @override
  void initState() {
    super.initState();
    _onOffense = true;
    _startedScouting = false;
    _stopGame = false;
    _stopwatch = new Stopwatch();
  }

  void toggleMode() {
    setState(() {
      _onOffense = !_onOffense;
    });
  }

  void endGame() {
    _stopGame = true;
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingMode;

    if (_onOffense) {
      scoutingMode = OffenseScouting(
        toggleMode: this.toggleMode,
        stopwatch: _stopwatch,
      );
    } else {
      scoutingMode = DefenseScouting(
        toggleMode: this.toggleMode,
        stopwatch: _stopwatch,
      );
    }

    return Scaffold(
      appBar: Header(context, 'Map Scouting'),
      body: Container(
        child: BlurOverlay(
          background: scoutingMode,
          text: Text('Start'),
          onEnd: () {
            setState(() {
              _startedScouting = true;
              _stopwatch.start();
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}