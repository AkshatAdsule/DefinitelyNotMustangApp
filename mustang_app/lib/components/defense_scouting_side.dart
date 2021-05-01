import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScoutingSide extends StatelessWidget {
  GlobalKey<ZoneGridState> zoneGridKey;
  GlobalKey<MapScoutingState> mapScoutingKey;

  DefenseScoutingSide({
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
                        .addAction(ActionType.PREV_INTAKE, context);
                  },
                  isDisabled: mapScoutingKey.currentState.pushTextStart,
                  text: 'Prevent Intake',
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
                        .addAction(ActionType.PREV_INTAKE, context);
                  },
                  isDisabled: mapScoutingKey.currentState.pushTextStart,
                  text: 'Prevent Shot',
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // TODO: make Game_Button take in a method to change the color for something
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: !mapScoutingKey.currentState.pushTextStart
                        ? Colors.green
                        : Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                        side: BorderSide(color: Colors.black, width: 1)),
                  ),
                  onPressed: () {
                    if (mapScoutingKey.currentState.pushTextStart
                        ? mapScoutingKey.currentState
                            .addAction(ActionType.PUSH_END, context)
                        : mapScoutingKey.currentState
                            .addAction(ActionType.PUSH_START, context))
                      mapScoutingKey.currentState.setPush();
                  },
                  child: Text(mapScoutingKey.currentState.pushTextStart
                      ? "Push End"
                      : "Push Start"),
                ),
                mapScoutingKey.currentState.pushTextStart
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                              side: BorderSide(color: Colors.black, width: 1)),
                        ),
                        onPressed: () {
                          mapScoutingKey.currentState.setPush();
                        },
                        child: Text("Cancel"),
                      )
                    : null,
              ].where((w) => w != null).toList(),
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
                    actionDeterminer(context, 'Foul');
                  },
                  isDisabled: mapScoutingKey.currentState.pushTextStart,
                  text: 'Foul',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
