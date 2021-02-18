import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import 'post_scouter.dart';
import '../../components/header.dart';
import '../../backend/scouting_operations.dart';

class PitScouter extends StatefulWidget {
  static const String route = '/PitScouter';
  static String _teamNumber;

  PitScouter({String teamNumber}) {
    _teamNumber = teamNumber;
  }

  @override
  _PitScouterState createState() => _PitScouterState(_teamNumber);
}

class _PitScouterState extends State<PitScouter> {
  String _teamNumber;
  DriveBase _driveBase = DriveBase.TANK;
  TextEditingController _notes = new TextEditingController();
  bool _inner = false,
      _outer = false,
      _bottom = false,
      _rotation = false,
      _position = false,
      _climb = false,
      _leveller = false;
  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(context, 'Pit Scouting'),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Drivebase Type',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  trailing: DropdownButton<DriveBase>(
                    value: _driveBase,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.green, fontSize: 20.0),
                    underline: Container(
                      height: 2,
                      color: Colors.green,
                    ),
                    onChanged: (DriveBase driveBase) {
                      setState(() {
                        _driveBase = driveBase;
                        //_driveBaseTest = newValue;
                      });
                    },
                    items: <DriveBase>[
                      DriveBase.TANK,
                      DriveBase.OMNI,
                      DriveBase.WESTCOAST,
                      DriveBase.MECANUM,
                      DriveBase.SWERVE
                    ].map<DropdownMenuItem<DriveBase>>((DriveBase driveBase) {
                      return DropdownMenuItem<DriveBase>(
                        value: driveBase,
                        child: Center(
                            child: Text(driveBase.toString().substring(
                                driveBase.toString().indexOf('.') + 1))),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green,
                  title: Center(
                    child: Text(
                      'Shooting Capability',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _outer,
                  onChanged: (bool val) {
                    setState(() {
                      _outer = val;
                    });
                  },
                  title: Text(
                    'Outer Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                CheckboxListTile(
                  value: _inner,
                  onChanged: (bool val) {
                    setState(() {
                      _inner = val;
                    });
                  },
                  title: Text(
                    'Inner Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                CheckboxListTile(
                  value: _bottom,
                  onChanged: (bool val) {
                    setState(() {
                      _bottom = val;
                    });
                  },
                  title: Text(
                    'Bottom Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green,
                  title: Center(
                    child: Text(
                      'Color Wheel',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _rotation,
                  onChanged: (bool val) {
                    setState(() {
                      _rotation = val;
                    });
                  },
                  title: Text(
                    'Rotation Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                CheckboxListTile(
                  value: _position,
                  onChanged: (bool val) {
                    setState(() {
                      _position = val;
                    });
                  },
                  title: Text(
                    'Position Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                ListTile(
                  tileColor: Colors.green,
                  title: Center(
                    child: Text(
                      'Climb Capability',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _climb,
                  onChanged: (bool val) {
                    setState(() {
                      _climb = val;
                    });
                  },
                  title: Text(
                    'Climber',
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _leveller,
                  onChanged: (bool val) {
                    setState(() {
                      _leveller = val;
                    });
                  },
                  title: Text(
                    'Leveller',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: TextField(
                    controller: _notes,
                    decoration: InputDecoration(
                      labelText: 'Final Comments',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                    onPressed: () {
                      ScoutingOperations.setTeamData(
                        Team(
                          _teamNumber,
                          _driveBase.toString(),
                          _notes.text,
                          _inner,
                          _outer,
                          _bottom,
                          _rotation,
                          _position,
                          _climb,
                          _leveller,
                        ),
                      );
                      Navigator.pushNamed(context, PostScouter.route);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

enum DriveBase { TANK, OMNI, WESTCOAST, MECANUM, SWERVE }
