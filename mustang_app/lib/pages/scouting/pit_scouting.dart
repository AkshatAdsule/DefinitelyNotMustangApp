import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/pages/scouting/post_scouter.dart';
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

enum DriveBase { TANK, OMNI, WESTCOAST, MECANUM, SWERVE }

class _PitScouterState extends State<PitScouter> {
  String _teamNumber;
  DriveBase _driveBase = DriveBase.TANK;
  TextEditingController _notes = new TextEditingController();
  List<List<Object>> boxStates = [
    ['Inner', null],
    ['Outer', null],
    ['Lower', null],
    ['Rotation', null],
    ['Position', null],
    ['Climb', null],
    ['Level', null],
  ];

  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  Widget createTitle(String text) {
    return ListTile(
      tileColor: Colors.green,
      title: Center(
        child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget createCheckBox(String text) {
    int i;
    for (int j = 0; j < boxStates.length; j++) {
      if ((boxStates[j].contains(text))) i = j;
    }
    String last = text.substring(text.length - 2);
    String label = text +
        (last == "er"
            ? " Port"
            : last == "on"
                ? " Control"
                : "er");
    return CheckboxListTile(
        value: boxStates[i][1] != null ? true : false,
        onChanged: (bool val) {
          setState(() {
            boxStates[i][1] == null
                ? boxStates[i][1] = true
                : boxStates[i][1] = !boxStates[i][1];
          });
        },
        title: Text(
          label,
          style: new TextStyle(fontSize: 20.0),
        ),
        activeColor: boxStates[i][1] == true ? Colors.green : Colors.red);
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
                createTitle("Shooting Capability"),
                createCheckBox("Inner"),
                createCheckBox("Outer"),
                createCheckBox("Lower"),
                createTitle("Color Wheel"),
                createCheckBox("Rotation"),
                createCheckBox("Position"),
                createTitle("Climb Capability"),
                createCheckBox("Climb"),
                createCheckBox("Level"),
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
                          boxStates[0][1],
                          boxStates[1][1],
                          boxStates[2][1],
                          boxStates[3][1],
                          boxStates[4][1],
                          boxStates[5][1],
                          boxStates[6][1],
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
