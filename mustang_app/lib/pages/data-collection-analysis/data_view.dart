import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/components/data_collection_tile.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/data-collection-analysis/view_graph_screen.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataViewScreen extends StatefulWidget {
  static const route = '/data_view';
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  Map<RobotFeatures, double> avgPointsPerFeature = {
    RobotFeatures.SHOOTER: 0,
    RobotFeatures.ELEVATOR: 0,
    RobotFeatures.CLIMBER: 0,
    RobotFeatures.CLAW: 0
  };

  List<DataCollectionYearData> data = [];

  Future<List<DataCollectionYearData>> getData() async {
    List<DataCollectionYearData> yearData = [];

    Map<RobotFeatures, List<double>> totalPointsPerFeature = {
      RobotFeatures.SHOOTER: [],
      RobotFeatures.ELEVATOR: [],
      RobotFeatures.CLIMBER: [],
      RobotFeatures.CLAW: [],
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

      for (RobotFeatures feature in Constants.ROBOT_FEATURES[year.year]) {
        totalPointsPerFeature[feature]
            .add(currentYearData.avgData.pointsScored);
      }

      yearData.add(
        currentYearData,
      );
    }

    avgPointsPerFeature = {
      RobotFeatures.CLAW:
          totalPointsPerFeature[RobotFeatures.CLAW].fold(0, (p, c) => p + c) /
              totalPointsPerFeature[RobotFeatures.CLAW].length,
      RobotFeatures.CLIMBER: totalPointsPerFeature[RobotFeatures.CLIMBER]
              .fold(0, (p, c) => p + c) /
          totalPointsPerFeature[RobotFeatures.CLIMBER].length,
      RobotFeatures.ELEVATOR: totalPointsPerFeature[RobotFeatures.ELEVATOR]
              .fold(0, (p, c) => p + c) /
          totalPointsPerFeature[RobotFeatures.ELEVATOR].length,
      RobotFeatures.SHOOTER: totalPointsPerFeature[RobotFeatures.SHOOTER]
              .fold(0, (p, c) => p + c) /
          totalPointsPerFeature[RobotFeatures.SHOOTER].length,
    };

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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "On average...",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Robots that had claws earned ${avgPointsPerFeature[RobotFeatures.CLAW].toStringAsFixed(2)} points",
                ),
                Text(
                  "Robots that had elevators earned ${avgPointsPerFeature[RobotFeatures.ELEVATOR].toStringAsFixed(2)} points",
                ),
                Text(
                  "Robots that had climbers earned ${avgPointsPerFeature[RobotFeatures.CLIMBER].toStringAsFixed(2)} points",
                ),
                Text(
                  "Robots that had shooters earned ${avgPointsPerFeature[RobotFeatures.SHOOTER].toStringAsFixed(2)} points",
                ),
              ],
            ),
          ),
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
              child: ElevatedButton(
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
            ),
          ),
        ],
      ),
    );
  }
}
