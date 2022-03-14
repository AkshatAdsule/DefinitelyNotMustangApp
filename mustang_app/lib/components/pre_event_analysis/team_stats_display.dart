import 'package:flutter/material.dart';
import 'package:mustang_app/utils/get_statistics.dart';
import './overall_score_display.dart';
import 'package:mustang_app/pages/pre_event_analysis/view_graph_screen.dart';
import 'package:mustang_app/models/team_statistic.dart';

class TeamStatsDisplay extends StatelessWidget {
  final TeamStatistic teamStatistic;
  final double score, max;

  /// creates a new TeamStatsDisplay with the given team statistics, score, and max score
  TeamStatsDisplay({this.teamStatistic, this.score, this.max});

  /// Formats the team name to be short enough to fit on the screen
  String formatTeamName(String teamName) {
    if (teamName.length < 38) {
      return teamName;
    } else {
      return teamName.substring(0, 35) + "...";
    }
  }

  /// build the display of a team's statistics including average opr, dpr, ccwm
  /// also builds a button below the text that links to a graph of the team's statistics over time
  /// builds a bar on the bottom indicating the teams overall rating out of a max score
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${teamStatistic.teamCode.substring(3)}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${formatTeamName(GetStatistics.getTeamName(teamStatistic.teamCode))}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'OPR: ${teamStatistic.oprAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.blue),
                ),
                Text(
                  'DPR: ${teamStatistic.dprAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'CCWM: ${teamStatistic.ccwmAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            MaterialButton(
              child: Text('View graph'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewGraphScreen(teamStatistic),
                  ),
                );
              },
              color: Colors.grey[300],
            ),
            OverAllScoreDisplay(
              score: score,
              maxScore: max,
            )
          ],
        ),
      ),
    );
  }
}
