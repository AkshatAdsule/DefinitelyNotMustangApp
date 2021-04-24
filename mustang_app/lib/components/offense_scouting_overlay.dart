import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import '../backend/game_action.dart';
import './game_map.dart';

// ignore: must_be_immutable
class OffenseScoutingOverlay extends StatelessWidget {
  void Function(ActionType type, BuildContext context) _addAction;
  void Function(double millisecondsElapsed) _setClimb;
  void Function() _onWheelPress;
  void Function(bool newVal) _setCrossedInitiationLine;
  Stopwatch _stopwatch;
  bool _completedRotationControl = false;
  bool _completedPositionControl = false;
  bool _crossedInitiationLine = false;

  OffenseScoutingOverlay({
    void Function(double millisecondsElapsed) setClimb,
    void Function(ActionType type, BuildContext context) addAction,
    void Function() onWheelPress,
    void Function(bool newVal) setCrossedInitiationLine,
    Stopwatch stopwatch,
    bool completedRotationControl,
    bool completedPositionControl,
    bool crossedInitiationLine,
  }) {
    _stopwatch = stopwatch;
    _addAction = addAction;
    _setClimb = setClimb;
    _setCrossedInitiationLine = setCrossedInitiationLine;
    _onWheelPress = onWheelPress;
    _completedRotationControl = completedRotationControl;
    _completedPositionControl = completedPositionControl;
    _crossedInitiationLine = crossedInitiationLine;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _completedRotationControl && _completedPositionControl
            ? Container()
            : GameMapChild(
                right: 65,
                bottom: 17.5,
                align: Alignment(-0.135, 0.815),
                child: GestureDetector(
                  onTap: () => _onWheelPress(),
                  child: CircleAvatar(
                    backgroundColor: !_completedRotationControl
                        ? Colors.green
                        : Colors.green.shade900,
                    child: Text(
                      !_completedRotationControl ? 'R' : 'P',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
        (_stopwatch.elapsedMilliseconds <= Constants.teleopStartMillis &&
                !_crossedInitiationLine)
            ? GameMapChild(
                align: Alignment(0, 0),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () {
                      _addAction(
                          ActionType.OTHER_CROSSED_INITIATION_LINE, context);
                      _setCrossedInitiationLine(true);
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
