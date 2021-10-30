import 'package:flutter/material.dart';
import 'package:mustang_app/models/team_statistic.dart';

// ignore: must_be_immutable
class ClassifierWidget extends StatelessWidget {
  final Classification classification;
  String _text;
  Color _bgColor;
  ClassifierWidget({this.classification}) {
    switch (classification) {
      case Classification.OFFENSIVE:
        this._text = 'OFFENSIVE';
        this._bgColor = Colors.blue;
        break;
      case Classification.DEFENSIVE:
        this._text = 'DEFENSIVE';
        this._bgColor = Colors.red;
        break;
      case Classification.NEUTRAL:
        this._text = 'NEUTRAL';
        this._bgColor = Colors.grey;
        break;
    }
  }

  static Classification getClassification(TeamStatistic teamStatistic) {
    double difference =
        (teamStatistic.dprAverage - teamStatistic.oprAverage).abs();

    //TODO Make these values better
    if (difference <= 5) {
      return Classification.NEUTRAL;
    } else if (teamStatistic.oprAverage > teamStatistic.dprAverage) {
      return Classification.OFFENSIVE;
    } else {
      return Classification.DEFENSIVE;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: this._bgColor,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(this._text),
        ),
      ),
    );
  }
}

enum Classification { OFFENSIVE, DEFENSIVE, NEUTRAL }
