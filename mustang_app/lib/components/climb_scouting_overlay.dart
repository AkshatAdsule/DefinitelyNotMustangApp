import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'dart:math';
import '../backend/game_action.dart';
import './game_map.dart';

// ignore: must_be_immutable
class ClimbScoutingOverlay extends StatelessWidget {
  GlobalKey<ZoneGridState> zoneGridKey;
  GlobalKey<MapScoutingState> mapScoutingKey;

  ClimbScoutingOverlay({
    this.zoneGridKey,
    this.mapScoutingKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameMapChild(
          align: Alignment(-0.06, -0.2),
          child: Transform.rotate(
            angle: -pi / 8,
            child: Container(
              height: 30,
              width: 200,
              child: Slider(
                divisions: 2,
                label: mapScoutingKey.currentState.sliderVal.round().toString(),
                onChanged: (newVal) =>
                    mapScoutingKey.currentState.setClimb(newVal),
                min: 1,
                max: 3,
                value: mapScoutingKey.currentState.sliderVal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
