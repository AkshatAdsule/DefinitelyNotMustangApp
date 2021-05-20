import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:provider/provider.dart';
import '../inputs/game_buttons.dart' as game_button;

// ignore: must_be_immutable
class OffenseScoutingSide extends StatelessWidget {
  OffenseScoutingSide();
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
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.RAISED,
                        type: game_button.ButtonType.MAKE,
                        onPressed: () {
                          mapScoutingKey.currentState
                              .addAction(ActionType.SHOT_OUTER, context);
                        },
                        text: 'Out'),
                    game_button.ScoutingButton(
                        style: game_button.ButtonStyle.RAISED,
                        type: game_button.ButtonType.MAKE,
                        onPressed: () {
                          mapScoutingKey.currentState
                              .addAction(ActionType.SHOT_INNER, context);
                        },
                        text: 'In'),
                  ],
                ),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_OUTER, context);
                    },
                    text: 'Miss'),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MAKE,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.SHOT_LOW, context);
                    },
                    text: 'Low'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_LOW, context);
                    },
                    text: 'Miss')
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MAKE,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.INTAKE, context);
                    },
                    text: 'Intake'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_INTAKE, context);
                    },
                    text: 'Miss')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
