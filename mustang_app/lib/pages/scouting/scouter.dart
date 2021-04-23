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

class _ScouterState extends State<Scouter> {
  TextEditingController _teamNumberController = TextEditingController();
  TextEditingController _matchNumberController = TextEditingController();

  String _allianceColor = "Blue";
  int _allianceNum = 0;

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
    return Screen(
      title: 'Pre Game Notes',
      child: ListView(children: <Widget>[
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
          child:
              // Row(children: [
              // DropdownButton<DriveBase>(
              //   value: _matchType,
              //   icon: Icon(Icons.arrow_downward),
              //   iconSize: 24,
              //   elevation: 16,
              //   style: TextStyle(color: Colors.green, fontSize: 20.0),
              //   underline: Container(
              //     height: 2,
              //     color: Colors.green,
              //   ),
              //   onChanged: (MatchType match) {
              //     setState(() {
              //       _matchType = match;
              //     });
              //   },
              //   items: <MatchType>[
              //     MatchType.QUAL,
              //     MatchType.PRELIM,
              //     MatchType.SEMIF,
              //     MatchType.FINAL,
              //   ].map<DropdownMenuItem<DriveBase>>((MatchType matchType) {
              //     return DropdownMenuItem<DriveBase>(
              //       value: matchType,
              //       child: Center(
              //           child: Text(matchType
              //               .toString()
              //               .substring(mathType.toString().indexOf('.') + 1))),
              //     );
              //   }).toList(),
              // ),
              TextField(
            controller: _matchNumberController,
            decoration: InputDecoration(
              labelText: 'Match Number',
              border: OutlineInputBorder(),
            ),
          ),
          //]),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: _allianceNum,
                      onChanged: (int value) {
                        setState(() {
                          _allianceNum = value;
                          _allianceColor = 'Blue';
                        });
                      }),
                  Text(
                    'Blue Alliance',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                      value: 1,
                      groupValue: _allianceNum,
                      onChanged: (int value) {
                        setState(() {
                          _allianceNum = value;
                          _allianceColor = 'Red';
                        });
                      }),
                  Text(
                    'Red Alliance',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //offense on right/left side
                  Text(
                    'Driver Station Side',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                      value: 0,
                      groupValue: _offenseNum,
                      onChanged: (int value) {
                        setState(() {
                          _offenseNum = value;
                          _offenseOnRightSide = false;
                        });
                      }),
                  Text(
                    'Left',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                      value: 1,
                      groupValue: _offenseNum,
                      onChanged: (int value) {
                        setState(() {
                          _offenseNum = value;
                          _offenseOnRightSide = true;
                        });
                      }),
                  Text(
                    'Right',
                    style: TextStyle(
                      fontSize: 16.0,
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
