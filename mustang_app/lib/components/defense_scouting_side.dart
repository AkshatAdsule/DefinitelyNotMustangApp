import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/utils/orientation_helpers.dart';
import './game_buttons.dart' as game_button;

// ignore: must_be_immutable
class DefenseScoutingSide extends StatelessWidget {
  bool Function(ActionType type, BuildContext context) _addAction;
  void Function() _toggleMode;
  void Function(List<int> newPrev) _setPrev;
  void Function(bool newVal) _setPush;
  List<int> _prev = [0, 0];
  bool _pushTextStart = false;

  DefenseScoutingSide(
      {Key key,
      void Function() toggleMode,
      bool Function(ActionType type, BuildContext context) addAction,
      void Function(List<int> newPrev) setPrev,
      void Function(bool newVal) setPush,
      List<int> prev,
      bool pushTextStart})
      : super(key: key) {
    _prev = prev;
    _setPrev = setPrev;
    _toggleMode = toggleMode;
    _addAction = addAction;
    _setPush = setPush;
    _pushTextStart = pushTextStart;
  }

  void actionDeterminer(BuildContext context, String action) {
    List<String> types = [
      // 'Reg',
      'Tech',
      'Red',
      'Yellow',
      'Disabled',
      'Disqual'
    ];
    List<FlatButton> optionButtons = new List<FlatButton>();

    for (String type in types) {
      FlatButton option = FlatButton(
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
    // set up the AlertDialog
    AlertDialog popUp = AlertDialog(
      title: Text(action),
      content: Text('Type of Foul'),
      actions: optionButtons,
    );

    // show the dialog
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                game_button.ScoutingButton(
                  style: game_button.ButtonStyle.RAISED,
                  type: game_button.ButtonType.TOGGLE,
                  onPressed: _toggleMode,
                  text: 'Offense',
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
                    if (_addAction(ActionType.PREV_INTAKE, context))
                      _setPrev([_prev[0] + 1, _prev[1]]);
                  },
                  text: 'Prevent Intake',
                ),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.FLAT,
                    type: game_button.ButtonType.COUNTER,
                    onPressed: () {},
                    text: _prev[0].toString()),
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
                    if (_addAction(ActionType.PREV_INTAKE, context))
                      _setPrev([_prev[0], _prev[1] + 1]);
                  },
                  text: 'Prevent Shot',
                ),
                game_button.ScoutingButton(
                    style: game_button.ButtonStyle.FLAT,
                    type: game_button.ButtonType.COUNTER,
                    onPressed: () {},
                    text: _prev[1].toString()),
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
                    if (_pushTextStart) {
                      if (_addAction(ActionType.PUSH_END, context))
                        _setPush(false);
                    } else {
                      if (_addAction(ActionType.PUSH_START, context))
                        _setPush(true);
                    }
                    _prev = [0, 0];
                  },
                  text: !_pushTextStart ? "Push Start" : "Push End",
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
                    actionDeterminer(context, 'Foul');
                    _prev = [0, 0];
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
