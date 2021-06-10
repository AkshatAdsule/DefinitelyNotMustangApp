import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataCollectionLineChartWidget extends StatelessWidget {
  final List<charts.Series<_LinearStats, DateTime>> data;
  final double height, width;

  DataCollectionLineChartWidget({this.data, this.height: 300, this.width: 50});

  static List<charts.Series<_LinearStats, DateTime>> createData(
      List<DataCollectionYearData> stats) {
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
      new charts.Series<_LinearStats, DateTime>(
        id: 'Accuracy',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_LinearStats stat, _) => stat.year,
        measureFn: (_LinearStats stat, _) => stat.stat,
        data: accuracyData,
      ),
      new charts.Series<_LinearStats, DateTime>(
        id: 'Ranking Points',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (_LinearStats stat, _) => stat.year,
        measureFn: (_LinearStats stat, _) => stat.stat,
        data: rankingPointsData,
      ),
      new charts.Series<_LinearStats, DateTime>(
        id: 'Win Rate',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (_LinearStats stat, _) => stat.year,
        measureFn: (_LinearStats stat, _) => stat.stat,
        data: winRateData,
      ),
    ];
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
class _LinearStats {
  final DateTime year;
  final double stat;

  _LinearStats(this.year, this.stat);
}
