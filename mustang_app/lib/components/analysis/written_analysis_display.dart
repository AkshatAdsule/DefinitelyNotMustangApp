// import 'package:flutter/material.dart';
// import 'package:mustang_app/models/team.dart';
// import 'package:mustang_app/models/match.dart';
// import 'package:mustang_app/services/keivna_analyzer.dart';
// import 'package:mustang_app/services/team_service.dart';
// import './map_analysis_text.dart';
// import 'package:mustang_app/components/shared/screen.dart';
// import 'package:provider/provider.dart';
// import 'package:mustang_app/services/analyzer.dart';

// // ignore: must_be_immutable
// class WrittenAnalysisDisplay extends StatelessWidget {
//   static const String route = '/WrittenAnalysisDisplay';
//   String _teamNumber = '';
//   // Analyzer _analyzer;
//     WrittenAnalysisDisplay({String teamNumber}) {

//   // WrittenAnalysisDisplay({Analyzer analyzer, String teamNumber}) {
//     // _analyzer = analyzer;
//     _teamNumber = teamNumber;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<Team>.value(
//       initialData: null,
//       value: TeamService.streamTeam(_teamNumber),
//       child: StreamProvider<List<Match>>.value(
//         value: TeamService.streamMatches(_teamNumber),
//         initialData: [],
//         child: WrittenAnalysisDisplayPage(
//           // analyzer: _analyzer,
//           teamNumber: _teamNumber,
//         ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class WrittenAnalysisDisplayPage extends StatefulWidget {
//   String _teamNumber = '';
//   // Analyzer _analyzer;

//   WrittenAnalysisDisplayPage({String teamNumber}) {
//     // _analyzer = analyzer;
//     _teamNumber = teamNumber;
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return new _WrittenAnalysisDisplayState(_teamNumber);
//   }
// }

// class _WrittenAnalysisDisplayState extends State<WrittenAnalysisDisplayPage> {
//   // Analyzer _analyzer;

//   _WrittenAnalysisDisplayState(String teamNumber) {
//     // _analyzer = analyzer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if (!_analyzer.initialized) {
//     //   //myAnalyzer.init().then((value) => setState(() {}));
//     // }
//     Team team = Provider.of<Team>(context);
//     List<Match> matches = Provider.of<List<Match>>(context);
    
//     return Screen(
//       title: 'Written Analysis for Team ' + (team != null ? team.teamNumber : ""),
//       includeBottomNav: false,
//       child: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:[Text(KeivnaAnalyzer.getWrittenAnalysis(matches))]
//             // children: <Widget>[MapAnalysisText()],
//           ),
//         ),
//       ),
//     );
//   }
// }
