import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import 'dart:math';
import '../backend/game_action.dart';
import './game_map.dart';

// ignore: must_be_immutable
class ClimbScoutingOverlay extends StatelessWidget {
  void Function(ActionType type, BuildContext context) _addAction;
  void Function(double millisecondsElapsed) _setClimb;
  Stopwatch _stopwatch;
  double _sliderValue = 2;

  ClimbScoutingOverlay({
    void Function(double millisecondsElapsed) setClimb,
    void Function(ActionType type, BuildContext context) addAction,
    Stopwatch stopwatch,
    double sliderValue,
  }) {
    _stopwatch = stopwatch;
    _addAction = addAction;
    _setClimb = setClimb;
    _sliderValue = sliderValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameMapChild(
          align: Alignment(-0.06, -0.2),
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
        ),
      ],
    );
  }
}
