import 'package:flutter/material.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'pit_scouting.dart';
import '../../backend/scouting_operations.dart';

class Scouter extends StatefulWidget {
  static const String route = '/Scouter';

  @override
  State<StatefulWidget> createState() {
    return new _ScouterState();
  }
}

enum MatchType { QUAL, QUARTER, SEMI, FINAL, OTHER, TYPE }

class _ScouterState extends State<Scouter> {
  TextEditingController _teamNumberController = TextEditingController();
  TextEditingController _matchNumberController = TextEditingController();
  MatchType _matchType = MatchType.OTHER;

  String _allianceColor = "Blue";

  bool _offenseOnRightSide = false;
  int _offenseNum = 0;

  bool _showError = false;

  showAlertDialog(BuildContext context, bool pit) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Override"),
      onPressed: () {
        Navigator.pop(context);
        if (pit) {
          Navigator.pushNamed(context, PitScouter.route, arguments: {
            'teamNumber': _teamNumberController.text,
          });
        } else {
          Navigator.pushNamed(context, MapScouting.route, arguments: {
            'teamNumber': _teamNumberController.text,
            'matchNumber': _matchType
                    .toString()
                    .substring(_matchType.toString().indexOf('.') + 1) +
                _matchNumberController.text,
            'allianceColor': _allianceColor,
            'offenseOnRightSide': _offenseOnRightSide,
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Overwrite Data"),
      content: Text(pit
          ? "Pit data for this team already.\nAre you sure you want to overwrite it?"
          : "Match data for this team and match number already.\nAre you sure you want to overwrite it?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Pre Game Notes',
      child: ListView(children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 15),
            child: TextField(
              controller: _teamNumberController,
              decoration: InputDecoration(
                labelText: 'Team Number',
                errorText: _showError ? 'Team number is required' : null,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                  child: TextField(
                    controller: _matchNumberController,
                    decoration: InputDecoration(
                      labelText: 'Match Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DropdownButton<MatchType>(
                    value: _matchType,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.green, fontSize: 20.0),
                    underline: Container(
                      height: 2,
                      color: Colors.green,
                    ),
                    onChanged: (MatchType matchType) {
                      setState(() {
                        _matchType = matchType;
                      });
                    },
                    items: <MatchType>[
                      MatchType.OTHER,
                      MatchType.QUAL,
                      MatchType.QUARTER,
                      MatchType.SEMI,
                      MatchType.FINAL,
                    ].map<DropdownMenuItem<MatchType>>((MatchType matchType) {
                      return DropdownMenuItem<MatchType>(
                        value: matchType,
                        child: Center(
                            child: Text(matchType.toString().substring(
                                matchType.toString().indexOf('.') + 1))),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Container(
                  padding: EdgeInsets.all(15), //(left: 10, right: 10),
                  child: ElevatedButton(
                      child: Text("Blue"),
                      onPressed: () {
                        setState(() {
                          _allianceColor = 'Blue';
                        });
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue)),
                ),
                Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text('Alliance', style: TextStyle(fontSize: 16.0))),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Red",
                    ),
                    onPressed: () {
                      setState(() {
                        _allianceColor = 'Red';
                      });
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //offense on right/left side
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                        child: Text("Left"),
                        onPressed: () {
                          setState(() {
                            _offenseOnRightSide = true;
                          });
                        }),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Driver Station Side',
                          style: TextStyle(fontSize: 16.0))),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      child: Text("Right"),
                      onPressed: () {
                        setState(() {
                          _offenseOnRightSide = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Builder(
                  builder: (BuildContext buildContext) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_teamNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(buildContext)
                              .showSnackBar(SnackBar(
                            content: Text("Enter a team number"),
                          ));
                          return;
                        }
                        ScoutingOperations.doesTeamDataExist(
                                _teamNumberController.text)
                            .then((exists) {
                          if (exists) {
                            showAlertDialog(context, true);
                          } else {
                            Navigator.pushNamed(context, PitScouter.route,
                                arguments: {
                                  'teamNumber': _teamNumberController.text,
                                });
                          }
                        });
                      });
                    },
                    child: Text(
                      'Pit Scouting',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Builder(
                  builder: (BuildContext buildContext) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_teamNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(buildContext)
                              .showSnackBar(SnackBar(
                            content: Text("Enter a team number"),
                          ));
                          return;
                        } else if (_matchType.toString().isEmpty) {
                          ScaffoldMessenger.of(buildContext)
                              .showSnackBar(SnackBar(
                            content: Text("Enter a match type"),
                          ));
                          return;
                        } else if (_matchNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(buildContext)
                              .showSnackBar(SnackBar(
                            content: Text("Enter a match number"),
                          ));
                          return;
                        }
                        ScoutingOperations.doesMatchDataExist(
                                _teamNumberController.text,
                                _matchNumberController.text)
                            .then((exists) {
                          if (exists) {
                            showAlertDialog(context, false);
                          } else {
                            ScoutingOperations.doesTeamDataExist(
                                    _teamNumberController.text)
                                .then((bool exists) {
                              if (!exists) {
                                ScoutingOperations.initTeamData(
                                    _teamNumberController.text);
                              }
                              Navigator.pushNamed(context, MapScouting.route,
                                  arguments: {
                                    'teamNumber': _teamNumberController.text,
                                    'matchNumber': _matchNumberController.text,
                                    'allianceColor': _allianceColor,
                                    'offenseOnRightSide': _offenseOnRightSide,
                                  });
                            });
                          }
                        });
                      });
                    },
                    child: Text(
                      'Match Scouting',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
