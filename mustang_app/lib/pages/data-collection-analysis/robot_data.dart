import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/models/robot.dart';

class RobotDataScreen extends StatefulWidget {
  final Map<OuttakeType, double> avgPointsPerOuttakeType;
  final Map<SecondarySubsystem, double> avgPointsPerSecondarySubsystem;

  const RobotDataScreen({
    this.avgPointsPerOuttakeType,
    this.avgPointsPerSecondarySubsystem,
  });

  @override
  _RobotDataScreenState createState() => _RobotDataScreenState();
}

class _RobotDataScreenState extends State<RobotDataScreen> {
  List<DataRow> _buildSubsystemRows() {
    List<DataRow> rows = [];
    for (SecondarySubsystem subsystem in SecondarySubsystem.values) {
      DataRow currentDataRow = DataRow(
        cells: [
          DataCell(
            Text(
              describeEnum(
                subsystem,
              ),
            ),
          ),
          DataCell(
            Text(
              widget.avgPointsPerSecondarySubsystem[subsystem]
                  .toStringAsFixed(2),
            ),
          ),
        ],
      );
      rows.add(currentDataRow);
    }
    return rows;
  }

  List<DataRow> _buildOuttakeRows() {
    List<DataRow> rows = [];
    for (OuttakeType outtake in OuttakeType.values) {
      DataRow currentDataRow = DataRow(
        cells: [
          DataCell(
            Text(
              describeEnum(
                outtake,
              ),
            ),
          ),
          DataCell(
            Text(
              widget.avgPointsPerOuttakeType[outtake].toStringAsFixed(2),
            ),
          ),
        ],
      );
      rows.add(currentDataRow);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robot Data"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Feature analysis
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Subsystem Analysis",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text("Subsystem"),
                        ),
                        DataColumn(
                          label: Text("Avg Points"),
                        ),
                      ],
                      rows: _buildSubsystemRows(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Outtake Analysis",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text("Subsystem"),
                        ),
                        DataColumn(
                          label: Text("Avg Points"),
                        ),
                      ],
                      rows: _buildOuttakeRows(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
