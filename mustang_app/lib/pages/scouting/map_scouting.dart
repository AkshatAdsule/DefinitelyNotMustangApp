import 'package:flutter/material.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/header.dart';
import 'defense_scouting.dart';
import 'offense_scouting.dart';

class MapScouting extends StatefulWidget {
  static const String route = '/MapScouter';

  @override
  _MapScoutingState createState() => _MapScoutingState();
}

class _MapScoutingState extends State<MapScouting> {
  bool _onOffense, _startedScouting;
  Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _onOffense = true;
    _startedScouting = false;
    _stopwatch = new Stopwatch();
  }

  void toggleMode() {
    setState(() {
      _onOffense = !_onOffense;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingMode, display;

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
    if (!_startedScouting) {
      display = BlurOverlay(
        background: scoutingMode,
        overlay: RaisedButton(
          color: Colors.red,
          onPressed: () {
            setState(() {
              _startedScouting = true;
            });
          },
          child: Text('Start'),
        ),
      );
    } else {
      display = scoutingMode;
    }
    return Scaffold(
      appBar: Header(context, 'Map Scouting'),
      body: Container(
        child: display,
      ),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
