import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import '../backend/game_action.dart';

// ignore: must_be_immutable
class DefenseScoutingOverlay extends StatelessWidget {
  GlobalKey<ZoneGridState> zoneGridKey;
  GlobalKey<MapScoutingState> mapScoutingKey;

  DefenseScoutingOverlay({
    this.zoneGridKey,
    this.mapScoutingKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}
