import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataCollectionLineChartWidget extends StatelessWidget {
  
  final List<charts.Series<LinearStats, DateTime>> data;
  final double height, width;

  DataCollectionLineChartWidget({this.data, this.height: 300, this.width: 50});

  static List<charts.Series<LinearStats, DateTime>> createData(
      List<DataCollectionYearData> stats) {
    List<LinearStats> accuracyData = [];
    List<LinearStats> rankingPointsData = [];
    List<LinearStats> winRateData = [];

    for (DataCollectionYearData yearStats in stats) {
      accuracyData.add(new LinearStats(yearStats.year, yearStats.avgData.percentageScored));
      rankingPointsData.add(new LinearStats(yearStats.year, yearStats.avgData.rankingPoints));
      winRateData.add(new LinearStats(yearStats.year, yearStats.winRate));
    }
    
    return [
      new charts.Series<LinearStats, DateTime> (
        id: 'Accuracy', 
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: accuracyData,
      ), 
      new charts.Series<LinearStats, DateTime> (
        id: 'Ranking Points', 
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
        data: rankingPointsData,
      ), 
      new charts.Series<LinearStats, DateTime> (
        id: 'Win Rate', 
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearStats stat, _) => stat.year,
        measureFn: (LinearStats stat, _) => stat.stat,
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
class LinearStats {
  final DateTime year;
  final double stat;

  LinearStats(this.year, this.stat);
}
