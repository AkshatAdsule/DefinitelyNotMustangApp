import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/teams_service.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';
import 'map_analysis_display.dart';
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

  showAlertDialog(BuildContext context, String teamNumber) {
    TextButton cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    TextButton goToAnalysis = TextButton(
      child: Text("Analysis"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, MapAnalysisDisplay.route, arguments: {
          'teamNumber': teamNumber,
        });
      },
    );
    TextButton goToData = TextButton(
      child: Text("Data"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, TeamInfoDisplay.route, arguments: {
          'teamNumber': teamNumber,
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Data View"),
      content: Text("Would you like to see defense analysis or data?"),
      actions: [cancelButton, goToAnalysis, goToData],
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
      child: ListView(
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
          // SizedBox(height: 10.0),
          Container(
            height: 500,
            child: (ListView.builder(
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
    );
  }
}
