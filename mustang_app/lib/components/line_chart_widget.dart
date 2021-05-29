import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/team_statistic.dart';

enum DataType { OPR, DPR, CCWM, WINRATE, CONTRIBUTION }

class LineChartWidget extends StatelessWidget {
  
  final List<charts.Series<LinearStats, DateTime>> data;
  final double height, width;

  LineChartWidget({this.data, this.height: 300, this.width: 50});

  static List<charts.Series<LinearStats, DateTime>> createTeamData(
      TeamStatistic stats) {
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

    for (var i = 1; i <= 2; i++) {
      predictedOprData.add(
        new LinearStats(
          currentYear.add(Duration(days: 365*i)) ,
          (stats.oprSlope + predictedOprData[i - 1].stat),
        ),
      );
      predictedDprData.add(
        new LinearStats(
          currentYear.add(Duration(days: 365*i)) ,
          (stats.dprSlope + predictedDprData[i - 1].stat),
        ),
      );
      predictedCcwmData.add(
        new LinearStats(
          currentYear.add(Duration(days: 365*i)) ,
          (stats.ccwmSlope + predictedCcwmData[i - 1].stat),
        ),
      );
      predictedWinRateData.add(
        new LinearStats(
          currentYear.add(Duration(days: 365*i)) ,
          (stats.winrateSlope + predictedWinRateData[i - 1].stat),
        ),
      );
      predictedPointContributionData.add(
        new LinearStats(
          currentYear.add(Duration(days: 365*i)) ,
          (stats.contributionSlope +
              predictedPointContributionData[i - 1].stat),
        ),
      );
    }

    return [
      new charts.Series<LinearStats, DateTime>(
        id: 'OPR',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: oprData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'DPR',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: dprData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'CCWM',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: ccwmData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'Win Rate',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: winRateData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'Contribution Percentage',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: pointContributionData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'predicted OPR',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: predictedOprData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'predicted DPR',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: predictedDprData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'predicted CCWM',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: predictedCcwmData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'predicted Win Rate',
        colorFn: (_, __) => charts.MaterialPalette.black,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: predictedWinRateData,
      ),
      new charts.Series<LinearStats, DateTime>(
        id: 'predicted CP',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        dashPatternFn: (_, __) => [8, 3, 2, 3],
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: predictedPointContributionData,
      ),
    ];
  }

  static Map<DataType, List<charts.Series<LinearStats, DateTime>>> createCompareData(
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
        new charts.Series(
          id: 'team1OPR',
          data: team1OprData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
        new charts.Series(
          id: 'team2OPR',
          data: team2OprData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
      ],
      DataType.DPR: [
        new charts.Series(
          id: 'team1DPR',
          data: team1DprData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
        new charts.Series(
          id: 'team2DPR',
          data: team2DprData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
      ],
      DataType.CCWM: [
        new charts.Series(
          id: 'team1CCWM',
          data: team1CcwmData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
        new charts.Series(
          id: 'team2CCWM',
          data: team2CcwmData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
      ],
      DataType.WINRATE: [
        new charts.Series(
          id: 'team1WinRate',
          data: team1WinRateData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
        new charts.Series(
          id: 'team2WinRate',
          data: team2WinRateData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
      ],
      DataType.CONTRIBUTION: [
        new charts.Series(
          id: 'team1Contribution',
          data: team1PointContributionData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
        new charts.Series(
          id: 'team2Contribution',
          data: team2PointContributionData,
          domainFn: (LinearStats data, _) => data.year,
          measureFn: (LinearStats data, _) => data.stat,
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new charts.TimeSeriesChart(
          this.data,
          animate: true,
          // domainAxis: new charts.NumericAxisSpec(
          //   viewport: new charts.NumericExtents(2001.0, 2020.0),
          // ),
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          behaviors: [
            new charts.ChartTitle('Year',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea),
            new charts.ChartTitle('Stat',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea),
            new charts.SeriesLegend(
              position: charts.BehaviorPosition.top,
              horizontalFirst: false,
              desiredMaxRows: 5,
              cellPadding: new EdgeInsets.only(right: 10.0, bottom: 5.0),
              entryTextStyle: charts.TextStyleSpec(fontSize: 10),
            )
          ],
        ),
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