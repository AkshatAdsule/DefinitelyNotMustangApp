import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import 'dart:math';
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
  double _sliderValue = 2;
  OffenseScoutingOverlay({
    void Function(double millisecondsElapsed) setClimb,
    void Function(ActionType type, BuildContext context) addAction,
    void Function() onWheelPress,
    void Function(bool newVal) setCrossedInitiationLine,
    Stopwatch stopwatch,
    bool completedRotationControl,
    bool completedPositionControl,
    bool crossedInitiationLine,
    double sliderValue,
  }) {
    _stopwatch = stopwatch;
    _addAction = addAction;
    _setClimb = setClimb;
    _setCrossedInitiationLine = setCrossedInitiationLine;
    _onWheelPress = onWheelPress;
    _completedRotationControl = completedRotationControl;
    _completedPositionControl = completedPositionControl;
    _crossedInitiationLine = crossedInitiationLine;
    _sliderValue = sliderValue;
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
                align: Alignment(-0.14, 0.73),
                child: CircleAvatar(
                  backgroundColor:
                      !_completedRotationControl ? Colors.green : Colors.blue,
                  child: IconButton(
                    onPressed: _onWheelPress,
                    icon: Icon(
                      Icons.donut_large,
                      color: Colors.white,
                    ),
                  ),
                )),
        _stopwatch.elapsedMilliseconds >= Constants.endgameStartMillis
            ? GameMapChild(
                align: Alignment(-0.07, -0.17),
                child: Transform.rotate(
                  angle: -pi / 8,
                  child: Container(
                    height: 30,
                    width: 200,
                    child: Slider(
                      divisions: 2,
                      label: _sliderValue.round().toString(),
                      onChanged: (newVal) => _setClimb(newVal),
                      min: 1,
                      max: 3,
                      value: _sliderValue,
                    ),
                  ),
                ),
              )
            : Container(),
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
