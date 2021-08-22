import 'package:flutter/material.dart';
import 'package:mustang_app/constants/game_constants.dart';

// ignore: must_be_immutable
class MapAnalysisKey extends StatelessWidget {
  bool _mapScoring;

  MapAnalysisKey(bool mapScoring) {
    _mapScoring = mapScoring;
  }

  // String _scoringText = Constants.minPtValuePerZonePerGame.toString() +
  //     " total pts                                                                     " +
  //     Constants.maxPtValuePerZonePerGame.toString() +
  //     " total pts";
  // String _accuracyText =
  //     "0%                                                                  100%";

  String _scoringText = GameConstants.minPtValuePerZonePerGame.toString() +
      "       total pts      " +
      GameConstants.maxPtValuePerZonePerGame.toString();
  String _accuracyText = "0%                 100%";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50], Colors.green[900]],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.horizontal(),
      ),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width, minHeight: 60.0),
        alignment: Alignment.center,
        child: Text(
          _mapScoring
              ? "Shooting Points Map\n" + "(avg per game)\n\n\n" + _scoringText
              : "Accuracy Map\n" + "(avg per game)\n\n\n" + _accuracyText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1,
          ),
        ),
      ),
    ));
  }
}
