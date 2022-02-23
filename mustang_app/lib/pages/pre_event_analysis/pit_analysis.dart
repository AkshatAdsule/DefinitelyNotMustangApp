import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mustang_app/components/shared/fancy_loading_overlay.dart';
import 'package:mustang_app/models/pitscouting_data.dart';

class PitAnalysis extends StatefulWidget {
  final List<String> teams;
  const PitAnalysis({Key key, this.teams}) : super(key: key);

  @override
  _PitAnalysisState createState() => _PitAnalysisState();
}

class _PitAnalysisState extends State<PitAnalysis> {
  bool _doneLoading = false;
  List<PitScoutingData> _data = [];
  List<PitScoutingData> _filteredData = [];
  List<FilterChip> _filters = [];
  List<FilterChip> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < PitScoutingData.ALL_CRITERIA.length; i++) {
      var criteria = PitScoutingData.ALL_CRITERIA[i];
      for (var c in criteria) {
        bool Function(PitScoutingData data) test;
        switch (i) {
          case 0:
            test = (data) => !data.intakeLocations.contains(c);
            break;
          case 1:
            test = (data) => !data.scoreLocations.contains(c);
            break;
          case 2:
            test = (data) => !data.hubTargets.contains(c);
            break;
          case 3:
            test = (data) => !data.climbLocations.contains(c);
            break;
        }
        _filters.add(FilterChip(
          label: c,
          test: test,
          instance: this,
          key: GlobalKey(),
        ));
      }
    }
    _acquireData(widget.teams);
  }

  void onFilterPressed(FilterChip filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
      _recalculateList();
    });
  }

  void _recalculateList() {
    List<PitScoutingData> newData = [..._data];
    for (var filter in selectedFilters) {
      newData.removeWhere(filter.test);
    }
    setState(() {
      _filteredData = newData;
    });
  }

  Future<void> _acquireData(List<String> teams) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference teamsCollection =
        instance.collection("2022/info/teams");
    for (String team in teams) {
      team = team.substring(3);
      try {
        var snapshot = await teamsCollection.doc(team).get();
        PitScoutingData teamData = PitScoutingData.fromJson(snapshot.data());
        _data.add(teamData);
      } catch (e) {}
    }
    setState(() {
      _filteredData = _data;
      _doneLoading = true;
    });
  }

  Widget _buildCheckBoxIndicator(String name, bool value) {
    return Row(
      children: [
        value
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
        Text(
          name,
          style: TextStyle(color: value ? Colors.black : Colors.red),
        ),
      ],
    );
  }

  Widget _buildDataSection({String title, List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamData(PitScoutingData data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.teamNumber,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _buildDataSection(title: "Auton", children: [
                Text(
                  "Auton Balls: ${data.autonBalls}",
                ),
              ]),
              _buildDataSection(title: "Intaking", children: [
                _buildCheckBoxIndicator(
                  "Terminal",
                  data.intakeLocations.contains("Terminal"),
                ),
                _buildCheckBoxIndicator(
                  "Field",
                  data.intakeLocations.contains("Field"),
                )
              ]),
              _buildDataSection(title: "Scoring Locations", children: [
                _buildCheckBoxIndicator(
                  "Against Fender",
                  data.scoreLocations.contains("Against Fender"),
                ),
                _buildCheckBoxIndicator(
                  "In Tarmac",
                  data.scoreLocations.contains("In Tarmac"),
                ),
                _buildCheckBoxIndicator(
                  "Outside Tarmac",
                  data.scoreLocations.contains("Outside Tarmac"),
                ),
              ]),
              _buildDataSection(title: "Hub Targets", children: [
                _buildCheckBoxIndicator(
                  "Lower",
                  data.hubTargets.contains("Lower"),
                ),
                _buildCheckBoxIndicator(
                  "Upper",
                  data.hubTargets.contains("Upper"),
                ),
              ]),
              _buildDataSection(title: "Climb", children: [
                _buildCheckBoxIndicator(
                  "Low",
                  data.climbLocations.contains("Low"),
                ),
                _buildCheckBoxIndicator(
                  "Middle",
                  data.climbLocations.contains("Middle"),
                ),
                _buildCheckBoxIndicator(
                  "High",
                  data.climbLocations.contains("High"),
                ),
                _buildCheckBoxIndicator(
                  "Traverse",
                  data.climbLocations.contains("Traverse"),
                ),
              ]),
              _buildDataSection(title: "General Comments", children: [
                Text(data.notes),
              ])
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pit Analysis"),
      ),
      body: LoadingOverlay(
        isLoading: !_doneLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: _filters,
                  ),
                ),
              ),
              _filteredData.length > 0
                  ? Column(
                      children: [
                        for (var datum in _filteredData) _buildTeamData(datum)
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                        child: Text(
                          "No teams match the filters",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterChip extends StatefulWidget {
  final String label;
  final bool Function(PitScoutingData data) test;
  final _PitAnalysisState instance;
  FilterChip({Key key, this.label, this.test, this.instance}) : super(key: key);

  @override
  State<FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<FilterChip> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5),
      child: GestureDetector(
        onTap: () {
          widget.instance.onFilterPressed(widget);
          setState(() {
            isSelected =
                widget.instance.selectedFilters.contains(widget) ?? false;
          });
        },
        child: Chip(
          label: Text(widget.label),
          backgroundColor: isSelected ?? false
              ? Colors.green.shade500
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}
