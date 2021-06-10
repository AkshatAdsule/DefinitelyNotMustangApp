import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/components/data_collection/data_collection_histogram_widget.dart';
import 'package:mustang_app/components/shared/header.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class View670HistogramScreen extends StatelessWidget {
  final DataCollectionYearData year;

  View670HistogramScreen(this.year);

  Widget buildCard(GamePieceResult dataType) {
    Map<GamePieceResult, List<charts.Series<HistogramStats, String>>> data;
    data = DataCollectionHistogramWidget.createData(year);
    List<charts.Series<HistogramStats, String>> graph = data[dataType];
    return Card(
      child: DataCollectionHistogramWidget(data: graph),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(
          context,
          year.year.toString(),
        ),
        body: ListView(
          children: [
            buildCard(GamePieceResult.ATTEMPTED),
            buildCard(GamePieceResult.SCORED)
          ],
        ));
  }
}
