import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/exports/pages.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class ClimbScoutingSide extends StatelessWidget {
  GlobalKey<ZoneGridState> zoneGridKey;
  GlobalKey<MapScoutingState> mapScoutingKey;

  ClimbScoutingSide({
    Key key,
    this.zoneGridKey,
    this.mapScoutingKey,
  }) : super(key: key);

  void actionDeterminer(BuildContext context, String action) {
    List<String> types = ['Tech', 'Red', 'Yellow', 'Disabled', 'Disqual'];
    List<TextButton> optionButtons = [];

    for (String type in types) {
      TextButton option = TextButton(
        child: Text(type),
        onPressed: () {
          mapScoutingKey.currentState.addAction(
              GameAction.stringToActionType(
                  action.toUpperCase() + "_" + type.toUpperCase()),
              context);
          Navigator.pop(context);
        },
      );
      optionButtons.add(option);
    }

    AlertDialog popUp = AlertDialog(
      title: Text(action),
      content: Text('Type of Foul'),
      actions: optionButtons,
    );

    showDialog(
      routeSettings: RouteSettings(arguments: ScreenOrientation.landscapeOnly),
      context: context,
      builder: (BuildContext context) {
        return popUp;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.ELEMENT,
                  onPressed: () {
                    mapScoutingKey.currentState
                        .addClimb(ActionType.OTHER_CLIMB_MISS);
                  },
                  text: 'No Park',
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.ELEMENT,
                  onPressed: () {
                    mapScoutingKey.currentState
                        .addClimb(ActionType.OTHER_PARKED);
                  },
                  text: 'Parked',
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.ELEMENT,
                  onPressed: () {
                    mapScoutingKey.currentState
                        .addClimb(ActionType.OTHER_CLIMB);
                  },
                  text: 'Climbed',
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.ELEMENT,
                  onPressed: () {
                    mapScoutingKey.currentState
                        .addClimb(ActionType.OTHER_LEVELLED);
                  },
                  text: 'Levelled',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
