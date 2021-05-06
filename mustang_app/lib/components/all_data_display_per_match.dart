import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class AllDataDisplayPerMatch extends StatefulWidget {
  Analyzer _analyzer;
  static const String route = '/AllDataDisplayPerMatch';

  AllDataDisplayPerMatch( {Analyzer analyzer}) {
    _analyzer = analyzer;
  }
  @override
  State<StatefulWidget> createState() {
    return new _AllDataDisplayPerMatchState(_analyzer);
  }
}

// class AllDataDisplayPerMatch extends StatelessWidget {
//   TeamService _teamService = TeamService();
//   static const String route = '/AllDataDisplayPerMatch';
//   String _teamNumber = '';
//   String _matchNum = '';
//   Analyzer _analyzer;

//   AllDataDisplayPerMatch({Analyzer analyzer, String teamNumber, String matchNum}) {
//     this._analyzer = analyzer;
//     _teamNumber = teamNumber;
//     _matchNum = matchNum;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<Team>.value(
//       initialData: null,
//       value: _teamService.streamTeam(_teamNumber),
//       child: StreamProvider<List<Match>>.value(
//         value: _teamService.streamMatches(_teamNumber),
//         initialData: [],
//         child: AllDataDisplayPerMatchPage(
//           analyzer: _analyzer,
//           teamNumber: _teamNumber,
//           matchNum: _matchNum,
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
// class AllDataDisplayPerMatchPage extends StatefulWidget {
//   String _teamNumber = '', _matchNum = '';
//   Analyzer _analyzer;
//   AllDataDisplayPerMatchPage({Analyzer analyzer, String teamNumber, String matchNum}) {
//     _analyzer = analyzer;
//     _teamNumber = teamNumber;
//     _matchNum = matchNum;
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return new _AllDataDisplayPerMatchState(_analyzer, _teamNumber, _matchNum);
//   }
// }

// class _AllDataDisplayPerMatchState extends State<AllDataDisplayPerMatchPage> {
  class _AllDataDisplayPerMatchState extends State<AllDataDisplayPerMatch> {

  Analyzer myAnalyzer;
  String _matchNum = '';

  //_AllDataDisplayPerMatchState(Analyzer analyzer, String teamNumber, String matchNum) {
  _AllDataDisplayPerMatchState(Analyzer analyzer) {

    //TODO: FIX THIS!!!!
    myAnalyzer = analyzer;
   // _matchNum = matchNum;
  }
  
  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      debugPrint("analyzer not initialized");
      myAnalyzer.init(
        Provider.of<Team>(context),
        Provider.of<List<Match>>(context),
      );
      setState(() {});
    }
    else{
            debugPrint("analyzer initialized");
            debugPrint("team num: " + myAnalyzer.teamNum.toString());

    }

    Widget dataText = Container(
      margin: EdgeInsets.all(10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(myAnalyzer.getReport(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          height: 4,

                          // background: Paint()
                          //   ..strokeWidth = 30.0
                          //   ..color = Colors.green[300]
                          //   ..style = PaintingStyle.stroke
                          //   //..strokeJoin = StrokeJoin.bevel,
                        ))
                  ],
                )),
          ]),
    );

    return Screen(
      title: 'All Data for Team: ' + myAnalyzer.teamNum + " - Match: " + _matchNum,
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              dataText
              ],
          ),
        ),
      ),
    );
  }
}
