import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataViewScreen extends StatefulWidget {
  static const route = '/data_view';
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  Future<dynamic> accessData(int row, int column) async {
    final csvData =
        await rootBundle.loadString('assets/data_collection/2019.csv');
    List<List<dynamic>> values = const CsvToListConverter().convert(csvData);
    print(values[row][column]);
    return values[row][column];
  }

  Future<void> testToMatchDataObject() async {
    List<List<dynamic>> data = CsvToListConverter().convert(
        await rootBundle.loadString('assets/data_collection/2019.csv'));

    print("Attempting ${data[1]}");
    DataCollectionMatchData matchData =
        DataCollectionMatchData.fromRow(data[1]);

    print(matchData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Collection Analysis"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Test'),
          onPressed: () {
            testToMatchDataObject();
          },
        ),
      ),
    );
  }
}
