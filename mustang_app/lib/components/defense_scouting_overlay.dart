import 'package:flutter/material.dart';
import '../backend/game_action.dart';

// ignore: must_be_immutable
class DefenseScoutingOverlay extends StatelessWidget {
  void Function(ActionType type, BuildContext context) _addAction;
  Stopwatch _stopwatch;

  DefenseScoutingOverlay({
    void Function(ActionType type, BuildContext context) addAction,
    Stopwatch stopwatch,
  }) {
    _stopwatch = stopwatch;
    _addAction = addAction;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
