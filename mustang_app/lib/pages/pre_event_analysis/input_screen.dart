import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/pages/pre_event_analysis/compare_teams.dart';
import 'package:mustang_app/utils/get_statistics.dart';

import 'sort_teams_screen.dart';

class InputScreen extends StatefulWidget {
  static const String route = '/inputScreen';
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String input;
  String inputEvent;
  String sortBy = "opr";
  List<String> teams = [];
  GetStatistics getStatistics = GetStatistics.getInstance();
  List<String> sortByValues = ['opr', 'dpr', 'ccwm', 'winRate'];

  TextEditingController inputController = TextEditingController();
  TextEditingController inputEventController = TextEditingController();

  Future<void> _getTeams() async {
    getStatistics.getTeams(inputEvent).then((teams) {
      setState(() {
        this.teams = teams;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Pre-Event Data Analyzer",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      teams = [];
                    });
                  },
                  onTap: () {
                    setState(() {
                      teams.removeLast();
                    });
                  },
                  child: Icon(Icons.remove),
                ),
              ),
              Expanded(
                flex: 6,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter teams',
                  ),
                  controller: inputController,
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => {
                    setState(() {
                      input = value;
                    })
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      teams.add("frc" + input);
                      inputController.text = "";
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 45,
              ),
              Expanded(
                flex: 6,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter event code',
                  ),
                  controller: inputEventController,
                  onChanged: (value) => {
                    setState(() {
                      inputEvent = value;
                    })
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.arrow_right_alt),
                  onPressed: () {
                    _getTeams();
                    inputEventController.text = "";
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: 20),
            Expanded(
                child: Center(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            height: 30, child: Text(teams.toString()))))),
            SizedBox(width: 20)
          ]),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text(
                  "Sort Teams",
                ),
                onPressed: teams.length > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SortTeamsPage(teams: teams, sortBy: sortBy),
                          ),
                        );
                      }
                    : null,
              ),
              ElevatedButton(
                child: Text(
                  "Compare Teams",
                ),
                // Enables button only if there are 2 selected teams
                onPressed: teams.length == 2
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompareTeams(
                              team1: teams[0],
                              team2: teams[1],
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
          SizedBox(height: 30),
          DropdownButton(
            hint: Text('Sort by'),
            value: sortBy,
            onChanged: (newValue) {
              setState(() {
                sortBy = newValue;
              });
            },
            items: sortByValues.map(
              (sortByValue) {
                return DropdownMenuItem(
                  child: new Text(sortByValue),
                  value: sortByValue,
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
