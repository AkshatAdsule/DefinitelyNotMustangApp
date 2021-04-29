import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import '../backend/game_action.dart';
import './game_map.dart';

// ignore: must_be_immutable
class OffenseScoutingOverlay extends StatelessWidget {
  GlobalKey<ZoneGridState> zoneGridKey;
  GlobalKey<MapScoutingState> mapScoutingKey;

  OffenseScoutingOverlay({
    this.mapScoutingKey,
    this.zoneGridKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapScoutingKey.currentState.completedRotationControl &&
                mapScoutingKey.currentState.completedPositionControl
            ? Container()
            : GameMapChild(
                right: 65,
                bottom: 17.5,
                align: Alignment(-0.135, 0.815),
                child: GestureDetector(
                  onTap: () => mapScoutingKey.currentState.onWheelPress(),
                  child: CircleAvatar(
                    backgroundColor:
                        !mapScoutingKey.currentState.completedRotationControl
                            ? Colors.green
                            : Colors.green.shade900,
                    child: Text(
                      !mapScoutingKey.currentState.completedRotationControl
                          ? 'R'
                          : 'P',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
        (mapScoutingKey.currentState.stopwatch.elapsedMilliseconds <=
                    Constants.teleopStartMillis &&
                !mapScoutingKey.currentState.crossedInitiationLine)
            ? GameMapChild(
                align: Alignment(0, 0),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () {
                      mapScoutingKey.currentState.addAction(
                          ActionType.OTHER_CROSSED_INITIATION_LINE, context);
                      mapScoutingKey.currentState
                          .setCrossedInitiationLine(true);
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
