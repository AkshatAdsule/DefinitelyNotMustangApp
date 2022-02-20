import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/map/game_map.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
//this dart file has the buttons for human shooting and if the robot crosses line

class OffenseScoutingOverlay extends StatelessWidget {
  OffenseScoutingOverlay();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ZoneGridState> zoneGridKey =
        Provider.of<GlobalKey<ZoneGridState>>(context);
    GlobalKey<MapScoutingState> mapScoutingKey =
        Provider.of<GlobalKey<MapScoutingState>>(context);

    return Stack(
      children: [
        // (mapScoutingKey.currentState.completedRotationControl &&
        //         mapScoutingKey.currentState.completedPositionControl &&
        //         (mapScoutingKey.currentState.stopwatch.elapsedMilliseconds <=
        //                 GameConstants.teleopStartMillis &&
        //             !mapScoutingKey.currentState.crossedInitiationLine))
        //     ? Container()
        //     : GameMapChild(
        //         right: 65,
        //         bottom: 17.5,
        //         align: Alignment(-1, 0.9),
        //         child: GestureDetector(
        //           onTap: () => mapScoutingKey.currentState.onWheelPress(),
        //           child: CircleAvatar(
        //             backgroundColor:
        //                 !mapScoutingKey.currentState.completedRotationControl
        //                     ? Colors.green
        //                     : Colors.green.shade900,
        //             child: Text(
        //               !mapScoutingKey.currentState.completedRotationControl
        //                   ? 'R'
        //                   : 'P',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //           ),
        //         )),
        (mapScoutingKey.currentState.stopwatch.elapsedMilliseconds <=
                    GameConstants.teleopStartMillis &&
                !mapScoutingKey.currentState.crossedInitiationLine)
            ? GameMapChild(
                align: Alignment(0, 0),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () {
                      mapScoutingKey.currentState.addAction(
                          ActionType.CROSSED_TARMAC, context);
                      mapScoutingKey.currentState
                          .setCrossedInitiationLine(true);
                    },
                  ),
                ),
              )
            : Container(),

        (mapScoutingKey.currentState.stopwatch.elapsedMilliseconds <=
                    GameConstants.teleopStartMillis &&
                !mapScoutingKey.currentState.humanShoot)
            ? GameMapChild(
                align: Alignment(-1, 0.9),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.sports_basketball, color: Colors.white),
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.HUMAN_PLAYER_SHOOTS, context);
                      mapScoutingKey.currentState.setHumanShoot(true);
                    },
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
