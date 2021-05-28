import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/components/data_collection_tile.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/data-collection-analysis/robot_data.dart';
import 'package:mustang_app/pages/data-collection-analysis/view_graph_screen.dart';
import 'package:mustang_app/utils/data_collection_data.dart';
import 'package:mustang_app/utils/robot.dart';

class DataViewScreen extends StatefulWidget {
  static const route = '/data_view';
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  Map<OuttakeType, double> avgPointsPerOuttakeType = {
    OuttakeType.SHOOTER: 0,
    OuttakeType.CLAW: 0,
  };

  Map<SecondarySubsystem, double> avgPointsPerSecondarySubsystem = {
    SecondarySubsystem.AUTONOMOUS: 0,
    SecondarySubsystem.ELEVATOR: 0,
    SecondarySubsystem.CLIMBER: 0,
    SecondarySubsystem.COLOR_PICKER: 0,
    SecondarySubsystem.VISION: 0,
  };

  List<DataCollectionYearData> data = [];

  Future<List<DataCollectionYearData>> getData() async {
    List<DataCollectionYearData> yearData = [];

    Map<OuttakeType, List<double>> totalPointsPerOuttakeType = {
      OuttakeType.SHOOTER: [],
      OuttakeType.CLAW: [],
    };

    Map<SecondarySubsystem, List<double>> totalPointsPerSecondarySubsystem = {
      SecondarySubsystem.AUTONOMOUS: [],
      SecondarySubsystem.ELEVATOR: [],
      SecondarySubsystem.CLIMBER: [],
      SecondarySubsystem.COLOR_PICKER: [],
      SecondarySubsystem.VISION: [],
    };

    for (int i = 0; i <= 7; i++) {
      DateTime year = new DateTime(2013 + i);

      String csvData = await rootBundle
          .loadString('assets/data_collection/${year.year}.csv');
      List<List<dynamic>> values = const CsvToListConverter().convert(csvData);

      List<DataCollectionMatchData> matchData = [];

      for (List<dynamic> row in values) {
        // Check if row is empty
        try {
          DataCollectionMatchData sampleData =
              DataCollectionMatchData.fromRow(row, year);
          matchData.add(sampleData);
        } catch (e) {
          print(e);
        }
      }

      DataCollectionYearData currentYearData = DataCollectionYearData(
        year: year,
        data: matchData,
        rankBeforeAllianceSelection: 0,
        endRank: 10,
      );

      for (SecondarySubsystem feature
          in Constants.robots[year.year].secondarySubsystems) {
        totalPointsPerSecondarySubsystem[feature]
            .add(currentYearData.avgData.pointsScored);
      }
      totalPointsPerOuttakeType[Constants.robots[year.year].outtakeType]
          .add(currentYearData.avgData.pointsScored);

      yearData.add(
        currentYearData,
      );
    }

    for (SecondarySubsystem subsystem in SecondarySubsystem.values) {
      avgPointsPerSecondarySubsystem[subsystem] =
          totalPointsPerSecondarySubsystem[subsystem].fold(0, (p, c) => p + c) /
              totalPointsPerSecondarySubsystem[subsystem].length;
    }

    for (OuttakeType type in OuttakeType.values) {
      avgPointsPerOuttakeType[type] =
          totalPointsPerOuttakeType[type].fold(0, (p, c) => p + c) /
              totalPointsPerOuttakeType[type].length;
    }

    return yearData;
  }

  @override
  void initState() {
    getData().then(
      (data) => {
        setState(() {
          this.data = data;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Collection Analysis"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Text(
              "Year Data",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          data.length == 0 || data == null
              ? Container()
              : Expanded(
                  flex: 10,
                  child: ListView(
                    children: [
                      for (var yearData in data)
                        DataCollectionYearTile(yearData)
                    ],
                  ),
                ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      "View Overall Data",
                    ),
                    onPressed: data.length > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    View670GraphScreen(statistic: data),
                              ),
                            );
                          }
                        : null,
                  ),
                  ElevatedButton(
                    child: Text("View Robot Data"),
                    onPressed: data.length > 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RobotDataScreen(
                                  avgPointsPerOuttakeType:
                                      avgPointsPerOuttakeType,
                                  avgPointsPerSecondarySubsystem:
                                      avgPointsPerSecondarySubsystem,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
