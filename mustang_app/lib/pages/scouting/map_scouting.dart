import 'package:flutter/material.dart';
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
  bool _onOffense;

  @override
  void initState() {
    super.initState();
    _onOffense = true;
  }

  void toggleMode() {
    setState(() {
      _onOffense = !_onOffense;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingMode;

    if (_onOffense) {
      scoutingMode = OffenseScouting(
        toggleMode: this.toggleMode,
      );
    } else {
      scoutingMode = DefenseScouting(
        toggleMode: this.toggleMode,
      );
    }
    return Scaffold(
      appBar: Header(context, 'Map Scouting'),
      body: Container(
        child: scoutingMode,
      ),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
