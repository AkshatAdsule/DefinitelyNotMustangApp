import 'package:flutter/material.dart';
import 'package:mustang_app/components/screen.dart';
import 'web_view_container.dart';

class GlossaryPage extends StatelessWidget {
  static const String route = './GlossaryPage';
  final _links = ['http://bit.ly/670glossaryold'];
  //infinite recharge game manual: ['https://firstfrc.blob.core.windows.net/frc2021/Manual/2021FRCGameManual.pdf']
  //final _links = ['http://bit.ly/670appglossary'];

  @override
  Widget build(BuildContext context) {
    return Screen(
        title: 'Links',
        includeBottomNav: true,
        child: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _links
                        .map((link) => _glossaryURL(context, link))
                        .toList()))));
  }

  Widget _glossaryURL(BuildContext context, String url1) {
    return Container(
        padding: EdgeInsets.all(20.0),
        //glossary google doc
        child: FlatButton(
          child: Text('Glossary Google Doc'),
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          //child: Text(url),
          onPressed: () => _handleURLButtonPress(context, url1),
        ));
  }

  Widget _gameManualURL(BuildContext context, String url1) {
    return Container(
        padding: EdgeInsets.all(20.0),
        //glossary google doc
        child: FlatButton(
          child: Text('Infinite Recharge Game Manual'),
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          //child: Text(url),
          onPressed: () => _handleURLButtonPress(context, url1),
        ));
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
