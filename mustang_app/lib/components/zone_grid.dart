import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class ZoneGrid extends StatefulWidget {
  _ZoneGridState _zoneGridState;
  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;

  ZoneGrid(
      Key key,
      Function(int x, int y) onTap,
      Widget Function(int x, int y, bool isSelected, double cellWidth,
              double cellHeight)
          createCell)
      : _zoneGridState = _ZoneGridState(onTap, createCell),
        _onTap = onTap,
        _createCell = createCell,
        super(key: key);

  int get x => _zoneGridState.x;

  int get y => _zoneGridState.y;

  bool get hasSelected => _zoneGridState.hasSelected;

  @override
  _ZoneGridState createState() {
    _zoneGridState = _ZoneGridState(_onTap, _createCell);
    return _zoneGridState;
  }
}

class _ZoneGridState extends State<ZoneGrid> {
  int _selectedX, _selectedY;
  bool _hasSelected;

  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;

  _ZoneGridState(this._onTap, this._createCell);

  @override
  void initState() {
    super.initState();
    _hasSelected = false;
    _selectedX = 0;
    _selectedY = 0;
  }

  int get x => _selectedX;

  int get y => _selectedY;

  bool get hasSelected => _hasSelected;

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
                setState(() {
                  _hasSelected =
                      _selectedX != j || _selectedY != i ? true : !_hasSelected;
                  _selectedX = j;
                  _selectedY = i;
                });
              },
              child: _createCell(
                  j,
                  i,
                  _hasSelected && _selectedX == j && _selectedY == i,
                  cellWidth,
                  cellHeight),
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
            children:
                _getTableContents(constraints.maxWidth, constraints.maxHeight),
          );
        },
      ),
    );
  }
}
