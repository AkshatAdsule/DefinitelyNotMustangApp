import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:provider/provider.dart';
import '../../models/game_action.dart';
import '../inputs/game_buttons.dart' as game_button;

// ignore: must_be_immutable
//all of the offense buttons that is on the right side
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.MAKE,
                  onPressed: () {
                    mapScoutingKey.currentState
                        .addAction(ActionType.SHOT_UPPER, context);
                  },
                  text: 'Shoot Upper',
                ),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_UPPER, context);
                    },
                    text: 'Miss Upper')
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
                          .addAction(ActionType.SHOT_LOWER, context);
                    },
                    text: 'Shoot Lower'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_LOWER, context);
                    },
                    text: 'Miss Lower')
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
                          .addAction(ActionType.TERMINAL_INTAKE, context);
                    },
                    text: 'Terminal Intake'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState.addAction(
                          ActionType.MISSED_TERMINAL_INTAKE, context);
                    },
                    text: 'Miss Terminal Intake')
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
                          .addAction(ActionType.GROUND_INTAKE, context);
                    },
                    text: 'Ground Intake'),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.RAISED,
                    type: game_button.ButtonType.MISS,
                    onPressed: () {
                      mapScoutingKey.currentState
                          .addAction(ActionType.MISSED_GROUND_INTAKE, context);
                    },
                    text: 'Miss Ground Intake')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

mixin GameActions {}
