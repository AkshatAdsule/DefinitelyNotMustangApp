import 'package:flutter/material.dart';
import 'package:mustang_app/components/LineChartWidget.dart';
import 'package:mustang_app/utils/TeamStatistic.dart';

class ViewGraphScreen extends StatelessWidget {
  final TeamStatistic _statistic;

  ViewGraphScreen(this._statistic);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _statistic.teamCode.substring(3),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              LineChartWidget(
            data: LineChartWidget.createTeamData(_statistic),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
          ),
        ),
      ),
    );
  }
}
