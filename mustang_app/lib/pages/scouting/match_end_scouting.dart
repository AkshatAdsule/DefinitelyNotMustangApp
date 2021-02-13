// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import 'package:mustang_app/components/game_action.dart';

import '../../backend/database_operations.dart';
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
  String _matchResult, _endState;
  TextEditingController _finalCommentsController = TextEditingController();
  bool _brokeDown;

  _MatchEndScouterState(
      this._teamNumber, this._matchNumber, this._allianceColor, this._actions);

  void _finishGame(BuildContext context) {
    if (_matchResult == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please select a match result"),
        duration: Duration(milliseconds: 1500),
      ));
      return;
    } else if (_endState == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please select an ending state"),
        duration: Duration(milliseconds: 1500),
      ));
      return;
    }

    GameAction climb = _actions.removeLast();
    switch (_endState) {
      case "Climbed":
        _actions.add(climb);
        break;
      case "Parked":
        climb.action = ActionType.OTHER_PARKED;
        _actions.add(climb);
        break;
      case "Levelled":
        climb.action = ActionType.OTHER_LEVELLED;
        _actions.add(climb);
        break;
      default:
        break;
    }
    DatabaseOperations.updateMatchData(_teamNumber, _matchNumber, _actions,
        finalComments: _finalCommentsController.text,
        matchResult: _matchResult,
        allianceColor: _allianceColor);
    Navigator.pushNamed(context, PostScouter.route);
  }

  @override
  void initState() {
    super.initState();
    _brokeDown = false;
  }

  @override
  void dispose() {
    super.dispose();
    _finalCommentsController.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: Header(
        context,
        'Match End',
      ),
      bottomNavigationBar: BottomNavBar(context),
      body: Builder(
        builder: (context) => Container(
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
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: DropdownButton<String>(
                  value: _endState,
                  hint: Text('Choose Ending State',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  items: <String>['Parked', 'Climbed', 'Levelled', 'None']
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        _endState = value;
                      },
                    );
                  },
                ),
              ),
              CheckboxListTile(
                title: Text(
                  'Did the robot break down?',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                value: _brokeDown,
                onChanged: (newVal) => setState(() => _brokeDown = newVal),
              ),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
