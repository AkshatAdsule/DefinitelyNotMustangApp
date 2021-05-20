import 'package:flutter/material.dart';
import 'package:mustang_app/models/team_statistic.dart';
import 'package:fl_chart/fl_chart.dart';

enum DataType { OPR, DPR, CCWM, WINRATE, CONTRIBUTION }

class LineChartWidget extends StatelessWidget {
  // final List<charts.Series> seriesList;
  // final bool animate;
  // final String teamCode;
  // final List<double> oprs;
  final List<LineChartBarData> data;
  final double height, width;
  static final List<int> dashArray = [5, 5];
  static final FlDotData dotData = FlDotData(
    show: false,
  );
  LineChartWidget({this.data, this.height: 300, this.width: 50});

  // LineChartWidget(this.seriesList, {this.animate});

  // /// Creates a [LineChart] with sample data and no transition.
  // LineChartWidget.withSampleData(String teamCode, List<double> oprs) {
  //   new LineChartWidget(
  //     _createData(teamCode, oprs),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  static List<LineChartBarData> createTeamData(TeamStatistic stats) {
    List<LinearStats> oprData = [];
    List<LinearStats> dprData = [];
    List<LinearStats> ccwmData = [];
    List<LinearStats> winRateData = [];
    List<LinearStats> pointContributionData = [];

    List<LinearStats> predictedOprData = [];
    List<LinearStats> predictedDprData = [];
    List<LinearStats> predictedCcwmData = [];
    List<LinearStats> predictedWinRateData = [];
    List<LinearStats> predictedPointContributionData = [];

    for (YearStats yearStat in stats.yearStats) {
      oprData.add(new LinearStats(yearStat.year, yearStat.avgOpr));
      dprData.add(new LinearStats(yearStat.year, yearStat.avgDpr));
      ccwmData.add(new LinearStats(yearStat.year, yearStat.avgCcwm));
      winRateData.add(new LinearStats(yearStat.year, yearStat.avgWinRate));
      pointContributionData
          .add(new LinearStats(yearStat.year, yearStat.avgPointContribution));
    }
    DateTime currentYear = stats.yearStats.last.year;
    predictedOprData
        .add(new LinearStats(currentYear, stats.yearStats.last.avgOpr));
    predictedDprData
        .add(new LinearStats(currentYear, stats.yearStats.last.avgDpr));
    predictedCcwmData
        .add(new LinearStats(currentYear, stats.yearStats.last.avgCcwm));
    predictedWinRateData
        .add(new LinearStats(currentYear, stats.yearStats.last.avgWinRate));
    predictedPointContributionData.add(new LinearStats(
        currentYear, stats.yearStats.last.avgPointContribution));
    for (int i = 1; i <= 2; i++) {
      DateTime newYear = currentYear.add(Duration(days: 366 * i));
      predictedOprData.add(
        new LinearStats(
          newYear.add(Duration(days: 366 * i)),
          (stats.oprSlope + predictedOprData[i - 1].stat),
        ),
      );
      predictedDprData.add(
        new LinearStats(
          newYear.add(Duration(days: 365 * i)),
          (stats.dprSlope + predictedDprData[i - 1].stat),
        ),
      );
      predictedCcwmData.add(
        new LinearStats(
          newYear.add(Duration(days: 365 * i)),
          (stats.ccwmSlope + predictedCcwmData[i - 1].stat),
        ),
      );
      predictedWinRateData.add(
        new LinearStats(
          newYear.add(Duration(days: 365 * i)),
          (stats.winrateSlope + predictedWinRateData[i - 1].stat),
        ),
      );
      predictedPointContributionData.add(
        new LinearStats(
          newYear.add(Duration(days: 365 * i)),
          (stats.contributionSlope +
              predictedPointContributionData[i - 1].stat),
        ),
      );
    }

    return [
      LineChartBarData(
        spots: oprData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.blue],
        dotData: dotData,
      ),
      LineChartBarData(
        spots: dprData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.red],
        dotData: dotData,
      ),
      LineChartBarData(
        spots: ccwmData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.green],
        dotData: dotData,
      ),
      LineChartBarData(
        spots: winRateData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.black],
        dotData: dotData,
      ),
      LineChartBarData(
        spots: pointContributionData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.purple],
        dotData: dotData,
      ),
      LineChartBarData(
        spots: predictedOprData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.blue],
        dotData: dotData,
        dashArray: dashArray,
      ),
      LineChartBarData(
        spots: predictedDprData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.red],
        dotData: dotData,
        dashArray: dashArray,
      ),
      LineChartBarData(
        spots: predictedCcwmData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.green],
        dotData: dotData,
        dashArray: dashArray,
      ),
      LineChartBarData(
        spots: predictedWinRateData
            .map((e) =>
                FlSpot(e.year.year.toDouble(), e.stat.round().toDouble()))
            .toList(),
        colors: [Colors.black],
        dotData: dotData,
        dashArray: dashArray,
      ),
      LineChartBarData(
        spots: predictedPointContributionData
            .map((e) => FlSpot(
                  e.year.year.toDouble(),
                  e.stat.round().toDouble(),
                ))
            .toList(),
        colors: [Colors.purple],
        dotData: dotData,
        dashArray: dashArray,
      ),
    ];
  }

  static Map<DataType, List<LineChartBarData>> createCompareData(
      TeamStatistic team1, TeamStatistic team2) {
    List<LinearStats> team1OprData = [], team2OprData = [];
    List<LinearStats> team1DprData = [], team2DprData = [];
    List<LinearStats> team1CcwmData = [], team2CcwmData = [];
    List<LinearStats> team1WinRateData = [], team2WinRateData = [];
    List<LinearStats> team1PointContributionData = [],
        team2PointContributionData = [];
    for (YearStats yearStat in team1.yearStats) {
      team1OprData.add(new LinearStats(yearStat.year, yearStat.avgOpr));
      team1DprData.add(new LinearStats(yearStat.year, yearStat.avgDpr));
      team1CcwmData.add(new LinearStats(yearStat.year, yearStat.avgCcwm));
      team1WinRateData.add(new LinearStats(yearStat.year, yearStat.avgWinRate));
      team1PointContributionData
          .add(new LinearStats(yearStat.year, yearStat.avgPointContribution));
    }

    for (YearStats yearStat in team2.yearStats) {
      team2OprData.add(new LinearStats(yearStat.year, yearStat.avgOpr));
      team2DprData.add(new LinearStats(yearStat.year, yearStat.avgDpr));
      team2CcwmData.add(new LinearStats(yearStat.year, yearStat.avgCcwm));
      team2WinRateData.add(new LinearStats(yearStat.year, yearStat.avgWinRate));
      team2PointContributionData
          .add(new LinearStats(yearStat.year, yearStat.avgPointContribution));
    }

    return {
      DataType.OPR: [
        LineChartBarData(
          spots: team1OprData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.blue],
          dotData: dotData,
        ),
        LineChartBarData(
          spots: team2OprData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.red],
          dotData: dotData,
        ),
      ],
      DataType.DPR: [
        LineChartBarData(
          spots: team1DprData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.blue],
          dotData: dotData,
        ),
        LineChartBarData(
          spots: team2DprData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.red],
          dotData: dotData,
        ),
      ],
      DataType.CCWM: [
        LineChartBarData(
          spots: team1CcwmData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.blue],
          dotData: dotData,
        ),
        LineChartBarData(
          spots: team2CcwmData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.red],
          dotData: dotData,
        ),
      ],
      DataType.WINRATE: [
        LineChartBarData(
          spots: team1WinRateData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.blue],
          dotData: dotData,
        ),
        LineChartBarData(
          spots: team2WinRateData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.red],
          dotData: dotData,
        ),
      ],
      DataType.CONTRIBUTION: [
        LineChartBarData(
          spots: team1PointContributionData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.blue],
          dotData: dotData,
        ),
        LineChartBarData(
          spots: team2PointContributionData
              .map((e) => FlSpot(
                    e.year.year.toDouble(),
                    e.stat.round().toDouble(),
                  ))
              .toList(),
          colors: [Colors.red],
          dotData: dotData,
        ),
      ],
    };
  }

  int roundUp(int n) {
    bool isNegative = n < 0;

    return isNegative ? -(((n.abs() + 4) ~/ 5) * 5) : (((n + 4) ~/ 5) * 5);
  }

  int roundDown(int n) {
    bool isNegative = n < 0;

    return isNegative ? roundUp(n) : (((n) ~/ 5) * 5);
  }

  @override
  Widget build(BuildContext context) {
    double minX = double.maxFinite, minY = double.maxFinite, maxX = 0, maxY = 0;
    data.forEach((element) {
      element.spots.forEach((element) {
        if (element.x < minX) {
          minX = element.x;
        }
        if (element.y < minY) {
          minY = element.y;
        }
        if (element.x > maxX) {
          maxX = element.x;
        }
        if (element.y > maxY) {
          maxY = element.y;
        }
      });
    });
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          // Flexible(
          //   flex: 1,
          //   child: LineChartLegend(),
          // ),
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LineChart(
                LineChartData(
                  minX: (minX.round()).toDouble(),
                  maxX: (maxX.round()).toDouble(),
                  minY: roundDown(minY.round()).toDouble(),
                  maxY: roundUp(maxY.round()).toDouble(),
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
                      interval: 25,
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
                      ),
                    ),
                    bottomTitle: AxisTitle(
                      showTitle: true,
                      titleText: 'Year',
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample linear data type.
class LinearStats {
  final DateTime year;
  final double stat;

  LinearStats(this.year, this.stat);
}

class LineChartLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      color: Colors.orangeAccent,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        children: [
          LineChartLegendItem(text: 'OPR', color: Colors.blue),
          LineChartLegendItem(text: 'DPR', color: Colors.red),
          LineChartLegendItem(text: 'CCWM', color: Colors.green),
          LineChartLegendItem(text: 'Win Rate', color: Colors.black),
          LineChartLegendItem(text: 'CP', color: Colors.purple),
          LineChartLegendItem(text: 'Predicted OPR', color: Colors.blue),
          LineChartLegendItem(text: 'Predicted DPR', color: Colors.red),
          LineChartLegendItem(text: 'Predicted CCWM', color: Colors.green),
          LineChartLegendItem(text: 'Predicted Win Rate', color: Colors.black),
          LineChartLegendItem(text: 'Predicted CP', color: Colors.purple),
        ],
      ),
    );
  }
}

class LineChartLegendItem extends StatelessWidget {
  final String text;
  final Color color;

  LineChartLegendItem({@required this.text, @required this.color});

  @override
  Widget build(BuildContext context) {
    print('here');
    print(MediaQuery.of(context).size.height / 10);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              foregroundColor: color,
              backgroundColor: color,
              child: Container(),
              radius: 20,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
