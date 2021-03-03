import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mustang_app/components/OverallScoreDisplay.dart';
import 'package:mustang_app/components/TeamStatsDisplay.dart';
import 'package:mustang_app/utils/TeamStatistic.dart';
import 'package:mustang_app/utils/getStatistics.dart';

class TeamStatsScreen extends StatefulWidget {
  static const route = '/teamStats';
  final List<String> teams;
  TeamStatsScreen({this.teams});
  @override
  _TeamStatsScreenState createState() => _TeamStatsScreenState();
}

class _TeamStatsScreenState extends State<TeamStatsScreen> {
  final GetStatistics _getStatistics = GetStatistics();
  List<double> _scores = [];
  double _max = 0;
  bool _done = false;
  List<TeamStatistic> _teamStatistics = [];

  Future<void> _init() async {
    await Firebase.initializeApp();
    for (String team in widget.teams) {
      _getStatistics.getCumulativeStats(team).then(
        (TeamStatistic stat) {
          setState(() {
            double score = (OverAllScoreDisplay.calculateScore(stat));
            if (score > _max) {
              _max = score;
            }
            _scores.add(score);
            _teamStatistics.add(stat);
          });
        },
      );
    }
    setState(() {
      _done = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ModalProgressHUD(
          inAsyncCall: !_done,
          child: _teamStatistics.length != 0
              ? ListView.separated(
                  itemCount: _teamStatistics.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) => TeamStatsDisplay(
                    teamStatistic: _teamStatistics[index],
                    score: _scores[index],
                    max: _max,
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
