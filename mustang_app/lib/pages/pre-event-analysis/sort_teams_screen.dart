import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mustang_app/components/overall_score_display.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/components/team_stats_display.dart';
import 'package:mustang_app/utils/team_statistic.dart';
import 'package:mustang_app/utils/get_statistics.dart';

class SortTeamsPage extends StatefulWidget {
  final List<String> teams;
  final String sortBy;

  SortTeamsPage({this.teams, this.sortBy});

  _SortTeamsPageState createState() => _SortTeamsPageState();
}

class _SortTeamsPageState extends State<SortTeamsPage> {
  List<TeamStatsDisplay> teamWidgets = [];
  GetStatistics getStatistics = new GetStatistics();

  double _maxScore = 0;
  bool gettingStatistics = true;

  void _onInit() async {
    List<TeamStatistic> teamStats = [];

    for (String team in widget.teams) {
      TeamStatistic currentTeamStats =
          await getStatistics.getCumulativeStats(team);
      double score = OverAllScoreDisplay.calculateScore(currentTeamStats);
      if (score > _maxScore) {
        _maxScore = score;
      }
      teamStats.add(currentTeamStats);
    }

    if (widget.sortBy == "opr") {
      teamStats.sort((a, b) => a.oprAverage.compareTo(b.oprAverage));
    } else if (widget.sortBy == "dpr") {
      teamStats.sort((a, b) => a.dprAverage.compareTo(b.dprAverage));
    } else if (widget.sortBy == "ccwm") {
      teamStats.sort((a, b) => a.ccwmAverage.compareTo(b.ccwmAverage));
    } else if (widget.sortBy == "winRate") {
      teamStats.sort((a, b) => a.winRateAverage.compareTo(b.winRateAverage));
    }

    for (int i = teamStats.length - 1; i >= 0; i--) {
      setState(() {
        teamWidgets.add(new TeamStatsDisplay(
          teamStatistic: teamStats[i],
          max: _maxScore,
          score: OverAllScoreDisplay.calculateScore(teamStats[i]),
        ));
      });
    }

    setState(() {
      gettingStatistics = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this._onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Pre-Event Data Analyzer",
      child: LoadingOverlay(
        isLoading: gettingStatistics,
        child: ListView.builder(
          itemCount: teamWidgets.length,
          itemBuilder: (BuildContext buildContext, int index) {
            return Dismissible(
                key: Key(teamWidgets[index].teamStatistic.teamCode),
                onDismissed: (direction) {
                  setState(
                    () {
                      teamWidgets.removeAt(index);
                    },
                  );
                },
                child: teamWidgets[index]);
          },
        ),
      ),
    );
  }
}
