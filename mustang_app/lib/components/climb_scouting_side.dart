import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class ClimbScoutingSide extends StatelessWidget {
  bool Function(ActionType type, BuildContext context) _addAction;
  void Function(double val) _setClimb;
  void Function(ActionType type) _addClimb;

  Widget _toggleMode;

  ClimbScoutingSide({
    Key key,
    Widget toggleMode,
    void Function(double val) setClimb,
    void Function(ActionType type) addClimb,
    bool Function(ActionType type, BuildContext context) addAction,
  }) : super(key: key) {
    _toggleMode = toggleMode;
    _addAction = addAction;
    _setClimb = setClimb;
    _addClimb = addClimb;
  }

  void actionDeterminer(BuildContext context, String action) {
    List<String> types = ['Tech', 'Red', 'Yellow', 'Disabled', 'Disqual'];
    List<TextButton> optionButtons = [];

    for (String type in types) {
      TextButton option = TextButton(
        child: Text(type),
        onPressed: () {
          _addAction(
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
                    _addClimb(ActionType.OTHER_CLIMB_MISS);
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
                    _addClimb(ActionType.OTHER_PARKED);
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
                    _addClimb(ActionType.OTHER_CLIMB);
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
                    _addClimb(ActionType.OTHER_LEVELLED);
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
