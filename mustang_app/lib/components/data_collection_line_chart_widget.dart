import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/team_statistic.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

enum DataType { OPR, DPR, CCWM, WINRATE, CONTRIBUTION }

class LineChartWidget extends StatelessWidget {
  // final List<charts.Series> seriesList;
  // final bool animate;
  // final String teamCode;
  // final List<double> oprs;
  final List<charts.Series<LinearStats, DateTime>> data;
  final double height, width;

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

  static List<charts.Series<LinearStats, DateTime>> createData(
      DataCollectionAverageYearData stats) {
    List<LinearStats> accuracyData = [];
    
  }

}

/// Sample linear data type.
class LinearStats {
  final DateTime year;
  final double stat;

  LinearStats(this.year, this.stat);
}