import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
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
  CheckBoxValues _innerVal = CheckBoxValues.NULL,
      _outerVal = CheckBoxValues.NULL,
      _bottomVal = CheckBoxValues.NULL,
      _rotationVal = CheckBoxValues.NULL,
      _positionVal = CheckBoxValues.NULL,
      _climbVal = CheckBoxValues.NULL,
      _levellerVal = CheckBoxValues.NULL;
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
                    child: Text('Shooting Capability',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                CheckboxListTile(
                  value: _outerVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_outerVal) {
                        case CheckBoxValues.NULL:
                          _outerVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _outerVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _outerVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Outer Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _outerVal == CheckBoxValues.TRUE
                      ? Colors.green
                      : Colors.red,
                ),
                CheckboxListTile(
                  value: _innerVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_innerVal) {
                        case CheckBoxValues.NULL:
                          _innerVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _innerVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _innerVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Inner Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _innerVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _innerVal == CheckBoxValues.TRUE
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _bottomVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_bottomVal) {
                        case CheckBoxValues.NULL:
                          _bottomVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _bottomVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _bottomVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Bottom Port',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _bottomVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _bottomVal == CheckBoxValues.TRUE
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
                  value: _rotationVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_rotationVal) {
                        case CheckBoxValues.NULL:
                          _rotationVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _rotationVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _rotationVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Rotation Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _rotationVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _rotationVal == CheckBoxValues.TRUE
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _positionVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_positionVal) {
                        case CheckBoxValues.NULL:
                          _positionVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _positionVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _positionVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Position Control',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _positionVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _positionVal == CheckBoxValues.TRUE
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
                  value: _climbVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_climbVal) {
                        case CheckBoxValues.NULL:
                          _climbVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _climbVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _climbVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Climber',
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  activeColor: _climbVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _climbVal == CheckBoxValues.TRUE
                          ? Colors.green
                          : Colors.red,
                ),
                CheckboxListTile(
                  value: _levellerVal == CheckBoxValues.NULL ? false : true,
                  onChanged: (bool val) {
                    setState(() {
                      switch (_levellerVal) {
                        case CheckBoxValues.NULL:
                          _levellerVal = CheckBoxValues.TRUE;
                          break;
                        case CheckBoxValues.TRUE:
                          _levellerVal = CheckBoxValues.FALSE;
                          break;
                        case CheckBoxValues.FALSE:
                          _levellerVal = CheckBoxValues.NULL;
                          break;
                        default:
                          break;
                      }
                    });
                  },
                  title: Text(
                    'Leveller',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  activeColor: _levellerVal == CheckBoxValues.NULL
                      ? Colors.white
                      : _levellerVal == CheckBoxValues.TRUE
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
