import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/constants/game_actions.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:provider/provider.dart';
import '../inputs/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class ClimbScoutingSide extends StatelessWidget {
  ClimbScoutingSide();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ZoneGridState> zoneGridKey =
        Provider.of<GlobalKey<ZoneGridState>>(context);
    GlobalKey<MapScoutingState> mapScoutingKey =
        Provider.of<GlobalKey<MapScoutingState>>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flexible(
          //   flex: 1,
          //   child: _toggleMode,
          // ),
          for (RobotAction action in GameActions.climbActions)
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.ELEMENT,
                    onPressed: () {
                      action.onPress(mapScoutingKey.currentState);
                    },
                    text: action.text,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
