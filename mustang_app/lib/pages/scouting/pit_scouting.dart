import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/pages/scouting/post_scouter.dart';
import '../../models/pitscouting_data.dart';
import '../../services/scouting_operations.dart';

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
  DriveBaseType _driveBase = DriveBaseType.TANK;
  Map<String, dynamic> state = {};

  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  Widget _scoutingSection(String title, List<Widget> questions) {
    return Column(
      children: [
        _title(title: title),
        ...questions,
      ],
    );
  }

  Widget _title({String title}) {
    return ListTile(
      tileColor: Colors.green,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, color: Colors.green),
      ),
    );
  }

  Widget _checkBox({String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Checkbox(
            value: state[title] ?? false,
            onChanged: (bool next) {
              setState(() {
                state[title] = !(state[title] ?? false);
                print(state);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _textField({String title, bool isNum}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        onChanged: (String val) {
          state[title] = val;
          print(state);
        },
        inputFormatters: isNum ? [FilteringTextInputFormatter.digitsOnly] : [],
        keyboardType: isNum
            ? TextInputType.numberWithOptions(signed: false, decimal: false)
            : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Pit Scouting',
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        reverse: true,
        child: Column(children: <Widget>[
          _title(title: "General"),
          ListTile(
            title: Text(
              'Drivebase Type',
              style: new TextStyle(fontSize: 16.0),
            ),
            trailing: DropdownButton<DriveBaseType>(
              value: _driveBase,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.green, fontSize: 16.0),
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              onChanged: (DriveBaseType driveBase) {
                setState(() {
                  _driveBase = driveBase;
                });
              },
              items: <DriveBaseType>[
                DriveBaseType.TANK,
                DriveBaseType.OMNI,
                DriveBaseType.WESTCOAST,
                DriveBaseType.MECANUM,
                DriveBaseType.SWERVE
              ].map<DropdownMenuItem<DriveBaseType>>((DriveBaseType driveBase) {
                return DropdownMenuItem<DriveBaseType>(
                  value: driveBase,
                  child: Center(
                      child: Text(driveBase
                          .toString()
                          .substring(driveBase.toString().indexOf('.') + 1))),
                );
              }).toList(),
            ),
          ),
          _scoutingSection(
            "Auton",
            [
              _textField(title: "Auton Balls", isNum: true),
            ],
          ),
          _scoutingSection(
            "Score Locations",
            [
              _checkBox(title: "Against Fender"),
              _checkBox(title: "In Tarmac"),
              _checkBox(title: "Outside of Tarmac"),
            ],
          ),
          _scoutingSection(
            "Intake Locations",
            [
              _checkBox(title: "Field"),
              _checkBox(title: "Terminal"),
            ],
          ),
          _scoutingSection(
            "Hub Score Locations",
            [
              _checkBox(title: "Lower"),
              _checkBox(title: "Upper"),
            ],
          ),
          _scoutingSection(
            "Climb",
            [
              _checkBox(title: "Low"),
              _checkBox(title: "Middle"),
              _checkBox(title: "High"),
              _checkBox(title: "Traverse"),
            ],
          ),
          _textField(title: "Final Comments", isNum: false),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                ScoutingOperations.setTeamData(
                  PitScoutingData.fromPitScoutingState(state,
                      teamNumber: _teamNumber, drivebaseType: _driveBase),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.all(15),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
