import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/pages/scouting/post_scouter.dart';
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
  bool _innerVal = null,
      _outerVal = null,
      _bottomVal = null,
      _rotationVal = null,
      _positionVal = null,
      _climbVal = null,
      _levellerVal = null;
  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
        title: 'Pit Scouting',
        child: SingleChildScrollView(
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
                    child: Text('Shooting Capability',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                CheckboxListTile(
                  value: _outerVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _outerVal = val;
                    });
                  },
                  title: Text(
                    'Outer Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _outerVal == true ? Colors.green : Colors.red,
                ),
                CheckboxListTile(
                  value: _innerVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _innerVal = val;
                    });
                  },
                  title: Text(
                    'Inner Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _innerVal == null
                      ? Colors.white
                      : _innerVal == true
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _bottomVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _bottomVal = val;
                    });
                  },
                  title: Text(
                    'Bottom Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _bottomVal == null
                      ? Colors.white
                      : _bottomVal == true
                          ? Colors.green
                          : Colors.red,
                ),
                ListTile(
                  tileColor: Colors.green,
                  title: Center(
                    child: Text('Color Wheel',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                CheckboxListTile(
                  value: _rotationVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _rotationVal = val;
                    });
                  },
                  title: Text(
                    'Rotation Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _rotationVal == null
                      ? Colors.white
                      : _rotationVal == true
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _positionVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _positionVal = val;
                    });
                  },
                  title: Text(
                    'Position Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _positionVal == null
                      ? Colors.white
                      : _positionVal == true
                          ? Colors.green
                          : Colors.red,
                ),
                ListTile(
                  tileColor: Colors.green,
                  title: Center(
                    child: Text('Climb Capability',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                CheckboxListTile(
                  value: _climbVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _climbVal = val;
                    });
                  },
                  title: Text(
                    'Climber',
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  activeColor: _climbVal == null
                      ? Colors.white
                      : _climbVal == true
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _levellerVal == null ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      _levellerVal = val;
                    });
                  },
                  title: Text(
                    'Leveller',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _levellerVal == null
                      ? Colors.white
                      : _levellerVal == true
                          ? Colors.green
                          : Colors.red,
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
                          _innerVal,
                          _outerVal,
                          _bottomVal,
                          _rotationVal,
                          _positionVal,
                          _climbVal,
                          _levellerVal,
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
