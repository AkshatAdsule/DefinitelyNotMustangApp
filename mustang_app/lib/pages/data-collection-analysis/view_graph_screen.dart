import 'package:flutter/material.dart';
import 'package:mustang_app/components/data_collection_line_chart_widget.dart';
import 'package:mustang_app/components/shared/header.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class View670GraphScreen extends StatelessWidget {
  final List<DataCollectionYearData> statistic;

  View670GraphScreen({this.statistic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        context,
        "All-time Team 670",
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              DataCollectionLineChartWidget(
            data: DataCollectionLineChartWidget.createData(statistic),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
          ),
        ),
      ),
    );
  }
}
