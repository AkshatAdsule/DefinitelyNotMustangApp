import 'package:flutter/material.dart';
import 'package:mustang_app/utils/team_statistic.dart';

class OverAllScoreDisplay extends StatelessWidget {
  final double maxScore, score;

  static const double OPR_WEIGHT = 1.0;
  static const double DPR_WEIGHT = 1.0;
  static const double CCWM_WEIGHT = 1.0;
  static const double WINRATE_WEIGHT = 1.0;
  static const double CONTRIBUTION_WEIGHT = 1.0;

  static double calculateScore(TeamStatistic teamStatistic) {
    return (teamStatistic.oprAverage * OPR_WEIGHT) +
        (teamStatistic.dprAverage * DPR_WEIGHT) +
        (teamStatistic.ccwmAverage * CCWM_WEIGHT) +
        (teamStatistic.winRateAverage * WINRATE_WEIGHT) +
        (teamStatistic.pointContributionAvg * CONTRIBUTION_WEIGHT);
  }

  OverAllScoreDisplay({this.score, this.maxScore});
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (score / maxScore),
    );
  }
}
