import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScoutingSide extends StatelessWidget {
  bool Function(ActionType type, BuildContext context) _addAction;
  void Function() _setPush;
  Widget _toggleMode;
  bool _pushTextStart;

  DefenseScoutingSide(
      {Key key,
      Widget toggleMode,
      void Function() setPush,
      bool Function(ActionType type, BuildContext context) addAction,
      bool pushTextStart})
      : super(key: key) {
    _toggleMode = toggleMode;
    _addAction = addAction;
    _setPush = setPush;
    _pushTextStart = pushTextStart;
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
          Flexible(
            flex: 1,
            child: _toggleMode,
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
                    // List<int> actionLoc =
                    _addAction(ActionType.PREV_INTAKE, context);
                    // actionLoc.add(0);
                    // print("actionLoc: " + actionLoc.toString());
                    // print("prevActionLoc: " + _prevActionLoc.toString());
                    // if (actionLoc[0] == _prevActionLoc[0] &&
                    //     actionLoc[1] == _prevActionLoc[1] &&
                    //     actionLoc[2] == _prevActionLoc[2]) {
                    //   _setCounter(_counter++);
                    // } else {
                    //   _setCounter(0);
                    //   _prevActionLoc[0] = actionLoc[0];
                    //   _prevActionLoc[1] = actionLoc[1];
                    //   _prevActionLoc[2] = actionLoc[2];
                    // }
                    // print(" AFTER  actionLoc: " + actionLoc.toString());
                    // print(
                    //     " AFTER  prevActionLoc: " + _prevActionLoc.toString());
                    // print("intake: " + _counter.toString());
                  },
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
                    _addAction(ActionType.PREV_INTAKE, context);
                  },
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
                      primary:
                          !_pushTextStart ? Colors.green : Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                          side: BorderSide(color: Colors.black, width: 1)),
                    ),
                    onPressed: () {
                      if (_pushTextStart
                          ? _addAction(ActionType.PUSH_END, context)
                          : _addAction(ActionType.PUSH_START, context))
                        _setPush();
                    },
                    child: Text(_pushTextStart ? "Push End" : "Push Start"))
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
                    actionDeterminer(context, 'Foul');
                  },
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
