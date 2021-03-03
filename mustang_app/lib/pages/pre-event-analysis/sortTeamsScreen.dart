import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mustang_app/components/OverallScoreDisplay.dart';
import 'package:mustang_app/components/teamWidget.dart';
import 'package:mustang_app/utils/TeamStatistic.dart';
import 'package:mustang_app/utils/getStatistics.dart';

class SortTeamsPage extends StatefulWidget {
  final List<String> teams;
  final String sortBy;

  SortTeamsPage({@required this.teams, @required this.sortBy});

  _SortTeamsPageState createState() => _SortTeamsPageState();
}

class _SortTeamsPageState extends State<SortTeamsPage> {
  List<TeamWidget> teamWidgets = [];
  GetStatistics getStatistics = new GetStatistics();

  double _maxScore = 0;
  bool gettingStatistics = true;

  void _onInit() async {
    await Firebase.initializeApp();
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
        teamWidgets.add(new TeamWidget(
          teamStatistic: teamStats[i],
          maxScore: _maxScore,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Mustang Pre-Event Data Analyzer"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: gettingStatistics,
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
