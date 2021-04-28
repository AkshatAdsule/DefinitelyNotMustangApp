import 'package:flutter/material.dart';
import 'web_view_container.dart';
class GlossaryPage extends StatelessWidget {
       static const String route = './GlossaryPage';

  // final _links = ['https://camellabs.com'];
     final _links = ['http://bit.ly/670glossary'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _links.map((link) => _urlButton(context, link)).toList(),
    ))));
  }
  Widget _urlButton(BuildContext context, String url) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Text(url),
          onPressed: () => _handleURLButtonPress(context, url),
        ));
  }
  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
// import 'package:flutter/material.dart';
// import 'package:mustang_app/components/screen.dart';

// // ignore: must_be_immutable
// // class GlossaryPage extends StatelessWidget {
// //   TeamsService _teamsService = TeamsService();
// //   static const String route = './Glossary';

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamProvider<List<Team>>.value(
// //       initialData: [],
// //       value: _teamsService.streamTeams(),
// //       child: Glossary(),
// //     );
// //   }
// // }

// class GlossaryPage extends StatefulWidget {
// //class GlossaryPage extends StatelessWidget {

//     static const String route = './GlossaryPage';

//   @override
//   // _GlossaryPageState createState() => new _GlossaryPageState();
//   State<StatefulWidget> createState() {
//     return _GlossaryPageState();
//   }
// }

// class _GlossaryPageState extends State<GlossaryPage> {


//   @override
//   Widget build(BuildContext context) {
//     return Screen(
//       title: 'Glossary ',
//       includeBottomNav: false,
//       child: Container(
//         child: SingleChildScrollView(
//           // child: Column(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: <Widget>[MapAnalysisText(myAnalyzer)],
//           // ),
//         ),
//       ),
//     );
//   }
// }
