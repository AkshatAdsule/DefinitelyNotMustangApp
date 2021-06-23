import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataCollectionLineChartWidget extends StatelessWidget {
  final List<LineChartBarData> data;
  final double height, width;

  DataCollectionLineChartWidget({this.data, this.height: 300, this.width: 50});

  static List<LineChartBarData> createData(List<DataCollectionYearData> stats) {
    List<_LinearStats> accuracyData = [];
    List<_LinearStats> rankingPointsData = [];
    List<_LinearStats> winRateData = [];

    for (DataCollectionYearData yearStats in stats) {
      accuracyData.add(
          new _LinearStats(yearStats.year, yearStats.avgData.percentageScored));
      rankingPointsData.add(
          new _LinearStats(yearStats.year, yearStats.avgData.rankingPoints));
      winRateData.add(new _LinearStats(yearStats.year, yearStats.winRate));
    }

    return [
      LineChartBarData(
        spots: accuracyData
            .map((e) => FlSpot(e.date.year.toDouble(), e.stat))
            .toList(),
        colors: [Colors.blue],
        dotData: FlDotData(show: false),
      ),
      LineChartBarData(
        spots: rankingPointsData
            .map((e) => FlSpot(e.date.year.toDouble(), e.stat))
            .toList(),
        colors: [Colors.red],
        dotData: FlDotData(show: false),
      ),
      LineChartBarData(
        spots: winRateData
            .map((e) => FlSpot(e.date.year.toDouble(), e.stat))
            .toList(),
        colors: [Colors.green],
        dotData: FlDotData(show: false),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //padding: const EdgeInsets.all(12.0),
      width: width,
      height: height,
      child: Column(
        children: [
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: data,
                  gridData: FlGridData(
                    horizontalInterval: 25,
                    verticalInterval: 5,
                  ),
                  borderData: FlBorderData(
                    border: Border(
                      left: BorderSide.none,
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 0.5,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitles: (double d) {
                        return d.toString();
                      },
                    ),
                  ),
                  axisTitleData: FlAxisTitleData(
                    show: true,
                    leftTitle: AxisTitle(
                      showTitle: true,
                      titleText: 'Stat',
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    bottomTitle: AxisTitle(
                      showTitle: true,
                      titleText: 'Year',
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      color: Colors.blue,
                    ),
                    new SizedBox(
                      width: 3
                    ),
                    new Text(
                      "Shooting Accuracy"
                    ),
                    new SizedBox(
                      width: 20
                    ), 
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      color: Colors.red,
                    ),
                    new SizedBox(
                      width: 3
                    ),
                    new Text(
                      "Ranking Points"
                    ),
                  ]
                ), 
                new SizedBox(
                  height: 10
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new SizedBox(
                      width: 20
                    ), 
                    new Container(
                      height: 10.0,
                      width: 10.0,
                      color: Colors.green,
                    ),
                    new SizedBox(
                      width: 3
                    ),
                    new Text(
                      "Win Rate"
                    ),
                  ],
                ),
                new SizedBox(
                  height: 10
                ), 
                new Text(
                  "Note: ranking points were not available for 2015",
                  style: new TextStyle(
                    color: Colors.grey
                  ),
                )
              ],
            )
          )
        ],
      ) 
    );
  }
}

/// Sample linear data type.
class _LinearStats {
  final DateTime date;
  final double stat;

  _LinearStats(this.date, this.stat);
}
