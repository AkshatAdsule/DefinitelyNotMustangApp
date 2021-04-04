import 'package:flutter/material.dart';
import 'package:mustang_app/components/line_chart_widget.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/utils/team_statistic.dart';

class ViewGraphScreen extends StatelessWidget {
  final TeamStatistic _statistic;

  ViewGraphScreen(this._statistic);
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: _statistic.teamCode.substring(3),
      child: Center(
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
