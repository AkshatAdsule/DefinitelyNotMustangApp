// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';

import '../../backend/scouting_operations.dart';
import '../../components/header.dart';
import 'post_scouter.dart';

// ignore: must_be_immutable
class MatchEndScouter extends StatefulWidget {
  static const String route = '/MatchEndScouter';
  String _teamNumber, _matchNumber, _allianceColor;
  List<GameAction> _actions;
  MatchEndScouter(
      {String teamNumber,
      String matchNumber,
      List<GameAction> actions,
      String allianceColor}) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _actions = actions;
    _allianceColor = allianceColor;
  }

  @override
  _MatchEndScouterState createState() => _MatchEndScouterState(
      _teamNumber, _matchNumber, _allianceColor, _actions);
}

class _MatchEndScouterState extends State<MatchEndScouter> {
  String _teamNumber, _matchNumber, _allianceColor;
  List<GameAction> _actions;
  String _matchResult;
  TextEditingController _finalCommentsController = TextEditingController();

  ScoutingOperations db = new ScoutingOperations();

  _MatchEndScouterState(
      this._teamNumber, this._matchNumber, this._allianceColor, this._actions);

  void _finishGame(BuildContext context) {
    db.updateMatchData(_teamNumber, _matchNumber, _actions,
        finalComments: _finalCommentsController.text,
        matchResult: _matchResult);
    Navigator.pushNamed(context, PostScouter.route);
  }

  @override
  Widget build(BuildContext context) {
    print(
        'ALLIANCE COLOR: $_allianceColor\nTEAM NUMBER: $_teamNumber\nMATCH NUMBER: $_matchNumber\n');
    _actions.forEach((element) => print(element.toString()));
    return Scaffold(
        appBar: Header(
          context,
          'Match End',
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              child: DropdownButton<String>(
                value: _matchResult,
                hint: Text('Choose Match Result',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                items: <String>['Win', 'Lose', 'Tie']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _matchResult = value;
                  });
                },
              ),
            ),
            // Container(
            //   padding:
            //       EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 30),
            //   child: Row(children: [
            //     Text('Not in action?',
            //         style: TextStyle(color: Colors.black, fontSize: 20)),
            //     TextField(
            //     controller: _finalCommentsController,
            //     decoration: InputDecoration(
            //       labelText: 'Final Comments',
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            //   ],
            // ), //TODO: add not in action
            Container(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 30),
              child: TextField(
                controller: _finalCommentsController,
                decoration: InputDecoration(
                  labelText: 'Final Comments',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              child: RaisedButton(
                  color: Colors.green,
                  onPressed: () => _finishGame(context),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        )));
  }
}
