// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/auth_service.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';
import '../../backend/match.dart';
import '../../backend/scouting_operations.dart';
import 'post_scouter.dart';

// ignore: must_be_immutable
class MatchEndScouter extends StatefulWidget {
  static const String route = '/MatchEndScouter';
  String _teamNumber, _matchNumber, _allianceColor;
  List<GameAction> _actions;
  double _climbLocation;
  bool _offenseOnRightSide;
  double _driverSkill;

  MatchEndScouter(
      {String teamNumber,
      String matchNumber,
      List<GameAction> actions,
      String allianceColor,
      bool offenseOnRightSide,
      double climbLocation,
      double driverSkill}) {
    _climbLocation = climbLocation;
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _actions = actions;
    _allianceColor = allianceColor;
    _offenseOnRightSide = offenseOnRightSide;
    _driverSkill = driverSkill;
  }

  @override
  _MatchEndScouterState createState() => _MatchEndScouterState(
      _teamNumber,
      _matchNumber,
      _allianceColor,
      _offenseOnRightSide,
      _actions,
      _climbLocation,
      _driverSkill);
}

class _MatchEndScouterState extends State<MatchEndScouter> {
  String _teamNumber, _matchNumber, _allianceColor;
  List<GameAction> _actions;
  String _matchResult, _endState;
  TextEditingController _finalCommentsController = TextEditingController();
  bool _brokeDown;
  double _climbLocation;
  bool _offenseOnRightSide;
  double _driverSkill;

  _MatchEndScouterState(
      this._teamNumber,
      this._matchNumber,
      this._allianceColor,
      this._offenseOnRightSide,
      this._actions,
      this._climbLocation,
      this._driverSkill);

  void _finishGame(BuildContext context, User user) {
    if (_matchResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a match result"),
        duration: Duration(milliseconds: 1500),
      ));
      return;
    }

    ScoutingOperations.setMatchData(
      new Match(_matchNumber, _teamNumber, _allianceColor, _offenseOnRightSide,
          _matchResult, _finalCommentsController.text, _driverSkill, _actions),
      user != null ? user.uid : 'Anonymous',
      user != null ? user.displayName : 'Anonymous',
    );
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
    User user = Provider.of<AuthService>(context).currentUser;

    return Screen(
      title: 'Match End',
      child: Builder(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text("Driver's skill",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: StarRating(
                            rating: _driverSkill,
                            onRatingChanged: (rating) =>
                                setState(() => this._driverSkill = rating),
                          )),
                    ),
                  ],
                ),
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.all(15),
                  ),
                  onPressed: () => _finishGame(context, user),
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

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color = Colors.green});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}
