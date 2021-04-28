import 'package:flutter/material.dart';
import 'package:mustang_app/components/data_collection_histogram_widget.dart';
import 'package:mustang_app/components/data_collection_line_chart_widget.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class View670HistogramScreen extends StatelessWidget {
  final DataCollectionYearData year;

  View670HistogramScreen(this.year);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        context,
        year.year.toString(),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              DataCollectionHistogramWidget(
            data: DataCollectionHistogramWidget.createData(year),
          ),
        ),
      ),
    );
  }
}
