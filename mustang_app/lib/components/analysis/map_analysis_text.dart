// import 'package:flutter/material.dart';
// import 'package:mustang_app/models/team.dart';
// import 'package:mustang_app/models/match.dart';
// import 'package:mustang_app/services/analyzer.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// //displays the written analysis is a legible, easy to read format
// //KTODO: IMPLEMENT THIS!!
// class WrittenAnalysisText extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new _WrittenAnalysisTextState();
//   }
// }

// class _WrittenAnalysisTextState extends State<WrittenAnalysisText> {
//   Analyzer myAnalyzer;

//   _WrittenAnalysisTextState() {
//     myAnalyzer = new Analyzer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!myAnalyzer.initialized) {
//       myAnalyzer.init(
//         Provider.of<Team>(context),
//         Provider.of<List<Match>>(context),
//       );
//       setState(() {});
//     }
//     return Container(
//       margin: EdgeInsets.all(10),
//       child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(myAnalyzer.getReport(),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey[800],
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           height: 4,
//                         ))
//                   ],
//                 )),
//           ]),
//     );
//   }
// }
