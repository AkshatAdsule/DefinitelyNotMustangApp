import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class ZoneGrid extends StatelessWidget {
  Function(int x, int y) _onTap;

  ZoneGrid(this._onTap);

  List<TableRow> _getTableContents(double width, double height) {
    List<TableRow> tableRows = [];
    final double cellWidth = width / Constants.zoneColumns,
        cellHeight = height / Constants.zoneRows;

    for (int i = 0; i < Constants.zoneRows; i++) {
      List<Widget> row = [];
      for (int j = 0; j < Constants.zoneColumns; j++) {
        row.add(
          TableCell(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _onTap(j, i);
                print("($j,$i)");
              },
              child: SizedBox(
                key: Key("($j,$i)"),
                height: cellHeight,
                width: cellWidth,
              ),
            ),
          ),
        );
      }
      tableRows.add(TableRow(children: row));
    }
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: _getTableContents(
                  constraints.maxWidth, constraints.maxHeight));
        },
      ),
    );
  }
}
