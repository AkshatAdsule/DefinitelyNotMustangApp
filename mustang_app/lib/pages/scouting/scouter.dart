import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'pit_scouting.dart';
import '../../components/header.dart';
import '../../backend/scouting_operations.dart';

class Scouter extends StatefulWidget {
  static const String route = '/Scouter';

  @override
  State<StatefulWidget> createState() {
    return new _ScouterState();
  }
}

class _ScouterState extends State<Scouter> {
  TextEditingController _teamNumberController = TextEditingController();
  TextEditingController _matchNumberController = TextEditingController();
  String _allianceColor = "Blue";
  int _allianceNum = 0;

  bool _offenseOnRightSide = true;
  bool _showError = false;
  /*
   _handleRadioValueChange (String color){
    setState(() {
      _allianceColor = color;
      switch(color){
        case "Blue Alliance" : { debugPrint("blue");}
        break;

        case "Red Alliance" : { debugPrint("red");}
        break;

        default: {debugPrint("default");}
        break;
      }
    });
  }
  */

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
            'matchNumber': _matchNumberController.text,
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
    return Scaffold(
      appBar: Header(
        context,
        'Pre Game Notes',
      ),
      body: ListView(children: <Widget>[
        Container(
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
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: TextField(
            controller: _matchNumberController,
            decoration: InputDecoration(
              labelText: 'Match Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                      value: 0,
                      groupValue: _allianceNum,
                      onChanged: (int value) {
                        setState(() {
                          _allianceNum = value;
                          _allianceColor = 'Blue';
                          Constants.fieldColor = value;
                        });
                      }),
                  new Text(
                    'Blue Alliance',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                      value: 1,
                      groupValue: _allianceNum,
                      onChanged: (int value) {
                        setState(() {
                          _allianceNum = value;
                          _allianceColor = 'Red';
                          Constants.fieldColor = value;
                        });
                      }),
                  new Text(
                    'Red Alliance',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              new Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //offense on right/left side
                  new Radio<bool>(
                      value: true,
                      groupValue: _offenseOnRightSide,
                      onChanged: (bool value) {
                        setState(() {
                          //_offenseNum = value;
                          _offenseOnRightSide = value;
                        });
                      }),
                  new Text(
                    'Offense Right Side',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio<bool>(
                      value: false,
                      groupValue: _offenseOnRightSide,
                      onChanged: (bool value) {
                        setState(() {
                          //_offenseNum = value;
                          _offenseOnRightSide = value;
                        });
                      }),
                  new Text(
                    'Offense Left Side',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
  
                ],
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: new Builder(
                  builder: (BuildContext buildContext) => RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        if (_teamNumberController.text.isEmpty) {
                          Scaffold.of(buildContext).showSnackBar(SnackBar(
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
                    padding: EdgeInsets.all(15),
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
                child: new Builder(
                  builder: (BuildContext buildContext) => new RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        if (_teamNumberController.text.isEmpty) {
                          Scaffold.of(buildContext).showSnackBar(SnackBar(
                            content: Text("Enter a team number"),
                          ));
                          return;
                        } else if (_matchNumberController.text.isEmpty) {
                          Scaffold.of(buildContext).showSnackBar(SnackBar(
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
                    padding: EdgeInsets.all(15),
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
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
