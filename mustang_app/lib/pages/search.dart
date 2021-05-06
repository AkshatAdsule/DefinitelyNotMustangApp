import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/teams_service.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/pages/all_data_display.dart';
import 'package:provider/provider.dart';
import 'map_analysis_display.dart';
import 'written_analysis_display.dart';
import 'team_info_display.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  TeamsService _teamsService = TeamsService();
  static const String route = './Search';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Team>>.value(
      initialData: [],
      value: _teamsService.streamTeams(),
      child: Search(),
    );
  }
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  List<String> _teams = [];
  List<String> _tempSearchStore = [];
  TextEditingController _queryController = new TextEditingController();

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        _tempSearchStore = _teams;
      });
      return;
    }

    List<String> temp = [];
    _teams.forEach((element) {
      if (element.startsWith(value)) {
        temp.add(element);
      }
    });
    setState(() {
      _tempSearchStore = temp;
    });
  }

  int font = 12;
  int size = 13;

  showAlertDialog(BuildContext context, String teamNumber) {
    TextButton cancelButton = TextButton(
      child: Text("Cancel", 
        style: TextStyle(fontSize: 15)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    TextButton goToMapAnalysis = TextButton(
      child: Text("Map", 
        style: TextStyle(fontSize: 15)),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, MapAnalysisDisplay.route, arguments: {
          'teamNumber': teamNumber,
        });
      },
    );
    TextButton goToWrittenAnalysis = TextButton(
      child: Text("Written Analysis", 
        style: TextStyle(fontSize: 15)),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, WrittenAnalysisDisplay.route, arguments: {
          'teamNumber': teamNumber,
        });
      },
    );
    TextButton goToAllData = TextButton(
      child: Text("Data", 
        style: TextStyle(fontSize: 15)),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AllDataDisplay.route, arguments: {
          'teamNumber': teamNumber,
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Data View"),
      content: Text("What would you like to see?"),
      // actions: [cancelButton, goToMapAnalysis, goToWrittenAnalysis, goToAllData, goToData],
      actions: [cancelButton, goToMapAnalysis, goToWrittenAnalysis, goToAllData],

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
  Widget build(BuildContext context) {
    List<Team> teams = Provider.of<List<Team>>(context);
    if (teams != null) {
      List<String> teamNumbers = teams.map((e) => e.teamNumber).toList();
      if (!listEquals<String>(teamNumbers, _teams)) {
        setState(() {
          _teams = teamNumbers;
          _tempSearchStore = teamNumbers;
        });
      }
    }
    return new Screen(
      title: 'Search Data',
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _queryController,
                onChanged: (val) {
                  initiateSearch(val);
                },
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0))),
              ),
            ),
            Expanded(
              child: (ListView.builder(
                shrinkWrap: true,
                itemCount: _tempSearchStore.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    showAlertDialog(context, _tempSearchStore[index]);
                  },
                  leading: Icon(Icons.people),
                  title: RichText(
                    text: TextSpan(
                      text: _tempSearchStore[index]
                          .substring(0, _queryController.text.length),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: _tempSearchStore[index]
                              .substring(_queryController.text.length),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
