import 'package:flutter/material.dart';
import 'package:mustang_app/components/pre_event_analysis/line_chart_widget.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/models/team_statistic.dart';

class ViewGraphScreen extends StatelessWidget {
  final TeamStatistic _statistic;

  ViewGraphScreen(this._statistic);

  // displays line chart widget on a screen
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: _statistic.teamCode.substring(3),
      child: Center(
        child: _statistic.yearStats != null && _statistic.yearStats.length > 0
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    LineChartWidget(
                  data: LineChartWidget.createTeamData(_statistic),
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  showLegend: true,
                ),
              )
            : Text(
                "Unexpected error! Could not process graph for ${_statistic.teamCode}."),
      ),
    );
  }
}
