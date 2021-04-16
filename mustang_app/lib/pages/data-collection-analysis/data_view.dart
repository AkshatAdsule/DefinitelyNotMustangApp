import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/components/data_collection_tile.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataViewScreen extends StatefulWidget {
  static const route = '/data_view';
  @override
  _DataViewScreenState createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> {
  List<DataCollectionYearData> data = [];

  Future<List<DataCollectionYearData>> getData() async {
    List<DataCollectionYearData> yearData = [];
    for (int i = 0; i <= 7; i++) {
      int year = 2013 + i;

      String csvData =
          await rootBundle.loadString('assets/data_collection/$year.csv');
      List<List<dynamic>> values = const CsvToListConverter().convert(csvData);

      List<DataCollectionMatchData> matchData = [];

      for (List<dynamic> row in values) {
        // Check if row is empty
        try {
          var sampleData = DataCollectionMatchData.fromRow(row);
          matchData.add(sampleData);
        } catch (e) {
          print(e);
        }
      }

      yearData.add(
        DataCollectionYearData(
          year: year,
          data: matchData,
          rankBeforeAllianceSelection: 0,
          endRank: 10,
        ),
      );
    }
    return yearData;
  }

  @override
  void initState() {
    getData().then(
      (data) => {
        setState(() {
          this.data = data;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Collection Analysis"),
      ),
      body: data.length == 0 || data == null
          ? Container()
          : ListView(
              children: [
                for (var yearData in data) DataCollectionYearTile(yearData)
              ],
            ),
    );
  }
}
