import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/models/robot.dart';
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
  List<TextEditingController> myController = List.generate(9, (i) => TextEditingController());
  List<String> prompts = [
     "1. What cool features does their robot have? What are they proud of?",
     "2. Describe their auton routine.",
     "3. Any final comments about the robot?",
     //below is for pit scouting
     "4. What is their battery capacity?",
     "5. What is their battery charge capacity?", 
     "6. Any cool new tools they are using?",
     "7. What are the pros and cons of their storage?", 
     "8. Is their pit asthetically pleasing? Why or why not?", 
     "9. Any final comments?",
  ];

  _PitScouterState(teamNumber) {
    _teamNumber = teamNumber;
  }

  Widget createTextQuestion(String question, int num) {
    return Column(
      children: <Widget>[
        Text(
          question, 
           textAlign: TextAlign.start,
             // textScaleFactor: 2.0,
              style: TextStyle (
               // fontWeight: FontWeight.w400,
                fontSize: 20.0,
                letterSpacing: 1.0,
                wordSpacing: 1.0,
              )
        ),
         SizedBox(height:10),
        TextField(
          controller: myController[num],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height:20),
      ],
    );
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
          _title(title: "Robot Questions"),
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
              _checkBox(title: "Outside Tarmac"),
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
                  //TODO could pass in new Team with Robot (as attribute)
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
