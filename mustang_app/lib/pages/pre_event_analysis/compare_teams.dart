import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mustang_app/components/pre_event_analysis/line_chart_widget.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/models/team_statistic.dart';
import 'package:mustang_app/utils/get_statistics.dart';

class CompareTeams extends StatefulWidget {
  final String team1, team2;
  CompareTeams({this.team1, this.team2});

  @override
  _CompareTeamsState createState() => _CompareTeamsState();
}

class _CompareTeamsState extends State<CompareTeams> {
  TeamStatistic _teamStatistic1, _teamStatistic2;
  GetStatistics getStatistics = GetStatistics.getInstance();
  Map<DataTypes, List<LineChartBarData>> data;
  bool _loading = true;

  Future<void> _onInit() async {
    _teamStatistic1 = await getStatistics.getCumulativeStats(widget.team1);
    _teamStatistic2 = await getStatistics.getCumulativeStats(widget.team2);
    data = LineChartWidget.createCompareData(_teamStatistic1, _teamStatistic2);
    setState(() {
      _loading = false;
    });
  }

  Widget buildCard(DataTypes dataType) {
    String type;
    List<LineChartBarData> data = this.data[dataType];
    double team1avg, team2avg;
    switch (dataType) {
      case DataTypes.OPR:
        type = 'OPR';
        team1avg = _teamStatistic1.oprAverage;
        team2avg = _teamStatistic2.oprAverage;
        break;
      case DataTypes.DPR:
        type = 'DPR';
        team1avg = _teamStatistic1.dprAverage;
        team2avg = _teamStatistic2.dprAverage;
        break;
      case DataTypes.CCWM:
        type = 'CCWM';
        team1avg = _teamStatistic1.ccwmAverage;
        team2avg = _teamStatistic2.ccwmAverage;
        break;
      case DataTypes.WINRATE:
        type = 'Win Rate';
        team1avg = _teamStatistic1.winRateAverage;
        team2avg = _teamStatistic2.winRateAverage;
        break;
      case DataTypes.CONTRIBUTION:
        team1avg = _teamStatistic1.pointContributionAvg;
        team2avg = _teamStatistic2.pointContributionAvg;
        type = 'Contribution';
        break;
    }
    return Card(
      elevation: 12,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text(
                  '$type',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${_teamStatistic1.teamCode} average $type: ${team1avg.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.blue),
                ),
                Text(
                  '${_teamStatistic2.teamCode} average $type: ${team2avg.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            LineChartWidget(data: data),
          ],
        ),
      ),
    );
  }

  Widget buildOverallCard() {
    return Card(
      elevation: 12,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[400],
      child: DataTable(columns: [
        DataColumn(label: Text('Statistic')),
        DataColumn(
            label: Text(
          _teamStatistic1.teamCode,
          style: TextStyle(color: Colors.blue),
        )),
        DataColumn(
            label: Text(
          _teamStatistic2.teamCode,
          style: TextStyle(color: Colors.red),
        ))
      ], rows: [
        DataRow(cells: [
          DataCell(Text('OPR')),
          DataCell(Text(_teamStatistic1.oprAverage.toStringAsFixed(2))),
          DataCell(Text(_teamStatistic2.oprAverage.toStringAsFixed(2)))
        ]),
        DataRow(cells: [
          DataCell(Text('DPR')),
          DataCell(Text(_teamStatistic1.dprAverage.toStringAsFixed(2))),
          DataCell(Text(_teamStatistic2.dprAverage.toStringAsFixed(2)))
        ]),
        DataRow(cells: [
          DataCell(Text('CCWM')),
          DataCell(Text(_teamStatistic1.ccwmAverage.toStringAsFixed(2))),
          DataCell(Text(_teamStatistic2.ccwmAverage.toStringAsFixed(2)))
        ]),
        DataRow(cells: [
          DataCell(Text('Winrate')),
          DataCell(Text(_teamStatistic1.winRateAverage.toStringAsFixed(2))),
          DataCell(Text(_teamStatistic2.winRateAverage.toStringAsFixed(2)))
        ]),
        DataRow(cells: [
          DataCell(Text('Contribution')),
          DataCell(
              Text(_teamStatistic1.pointContributionAvg.toStringAsFixed(2))),
          DataCell(
              Text(_teamStatistic2.pointContributionAvg.toStringAsFixed(2)))
        ]),
      ]),
    );
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Comparing ${widget.team1} and ${widget.team2}",
      child: LoadingOverlay(
        isLoading: _loading,
        child: ListView(
          children: _loading
              ? []
              : [
                  buildOverallCard(),
                  buildCard(DataTypes.OPR),
                  buildCard(DataTypes.DPR),
                  buildCard(DataTypes.CCWM),
                  buildCard(DataTypes.WINRATE),
                  buildCard(DataTypes.CONTRIBUTION),
                ],
        ),
      ),
    );
  }
}
