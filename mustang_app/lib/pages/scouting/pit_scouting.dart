import 'package:flutter/material.dart';
import 'post_scouter.dart';
import '../../components/header.dart';
import '../../backend/database_operations.dart';

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
  DriveBase _driveBase;
  TextEditingController _notes = new TextEditingController();
  bool _inner = false,
      _outer = false,
      _bottom = false,
      _rotation = false,
      _position = false,
      _climb = false,
      _leveller = false;
  String _drivebaseType = "";
  String _driveBaseTest = "Drive Base";

  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(context, 'Pit Scouting'),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: _driveBaseTest,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.green),
                underline: Container(
                  height: 2,
                  color: Colors.green,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    switch (newValue) {
                      case "Tank":
                        {
                          _driveBase = DriveBase.TANK;
                        }
                        break;
                      case "Omni":
                        {
                          _driveBase = DriveBase.OMNI;
                        }
                        break;
                      case "WestCoast":
                        {
                          _driveBase = DriveBase.WESTCOAST;
                        }
                        break;
                      case "Mecanum":
                        {
                          _driveBase = DriveBase.MECANUM;
                        }
                        break;
                      case "Swerve":
                        {
                          _driveBase = DriveBase.SWERVE;
                        }
                        break;
                    }
                    //_driveBaseTest = newValue;
                  });
                },
                items: <String>[
                  'Drive Base',
                  'Tank',
                  'Omni',
                  'WestCoast',
                  'Mecanum',
                  'Swerve'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                //items: null, onChanged: null
              ),
              //old drive base setup
              /*
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                
                child: Text(
                    'Drivebase Type:',
                    style: TextStyle(fontSize: 20),
                  ),
                
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'Short',
                    groupValue: _drivebaseType,
                    onChanged: (onchange) {
                      setState(() {
                        _drivebaseType = onchange;
                      });
                    },
                  ),
                  Text(
                    'Short',
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                    value: 'Tall',
                    groupValue: _drivebaseType,
                    onChanged: (onchange) {
                      setState(() {
                        _drivebaseType = onchange;
                      });
                    },
                  ),
                  Text(
                    'Tall',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              */
              Text(
                'Shooting Capability',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: CheckboxListTile(
                      value: _outer,
                      onChanged: (bool val) {
                        setState(() {
                          _outer = val;
                        });
                      },
                      title: Center(
                        child: Text(
                          'Outer\n Port',
                          style: new TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: CheckboxListTile(
                      value: _inner,
                      onChanged: (bool val) {
                        setState(() {
                          _inner = val;
                        });
                      },
                      title: Center(
                        child: Text(
                          'Inner\n Port',
                          style: new TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 200,
                child: CheckboxListTile(
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
              ),
              Text(
                'Color Wheel',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: 250,
                child: CheckboxListTile(
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
              ),
              Container(
                width: 250,
                child: CheckboxListTile(
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
              ),
              Text(
                'Climb Capability',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: CheckboxListTile(
                      value: _climb,
                      onChanged: (bool val) {
                        setState(() {
                          _climb = val;
                        });
                      },
                      title: Center(
                        child: Text(
                          'Climber',
                          style: new TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: CheckboxListTile(
                      value: _leveller,
                      onChanged: (bool val) {
                        setState(() {
                          _leveller = val;
                        });
                      },
                      title: Center(
                        child: Text(
                          'Leveller',
                          style: new TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ],
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

              RaisedButton(
                onPressed: () {
                  DatabaseOperations.updatePitScouting(_teamNumber,
                      //drivebaseType: _drivebaseType,
                      drivebaseType: _driveBase.toString(),
                      inner: _inner,
                      outer: _outer,
                      bottom: _bottom,
                      rotation: _rotation,
                      position: _position,
                      climb: _climb,
                      leveller: _leveller,
                      notes: _notes.text);
                  Navigator.pushNamed(context, PostScouter.route);
                  // Navigator.pushNamed(context, TeleopScouter.route);
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
            ],
          ),
        ));
  }
}

enum DriveBase { TANK, OMNI, WESTCOAST, MECANUM, SWERVE }
