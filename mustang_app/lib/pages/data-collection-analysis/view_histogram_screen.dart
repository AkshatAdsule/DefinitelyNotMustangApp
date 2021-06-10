import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/data_collection/data_collection_histogram_widget.dart';
import 'package:mustang_app/components/shared/header.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class View670HistogramScreen extends StatelessWidget {
  final DataCollectionYearData year;

  View670HistogramScreen(this.year);

  Widget buildCard(GamePieceResult dataType) {
    Map<GamePieceResult, List<BarChartGroupData>> data;
    data = DataCollectionHistogramWidget.createData(year);
    List<BarChartGroupData> graph = data[dataType];
    return SizedBox(
      height: 300,
      width: 500,
      child: Card(
        child: DataCollectionHistogramWidget(graph),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(
          context,
          year.year.year.toString(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(child: buildCard(GamePieceResult.ATTEMPTED)),
              Expanded(child: buildCard(GamePieceResult.SCORED))
            ],
          ),
        ));
  }
}
