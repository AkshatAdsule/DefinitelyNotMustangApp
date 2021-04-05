import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class ZoneGrid extends StatefulWidget {
  _ZoneGridState _zoneGridState;
  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;
  int _rows, _cols;

  ZoneGrid(
    Key key,
    Function(int x, int y) onTap,
    Widget Function(
            int x, int y, bool isSelected, double cellWidth, double cellHeight)
        createCell, {
    int rows = Constants.zoneRows,
    int cols = Constants.zoneColumns,
  })  : _zoneGridState = _ZoneGridState(onTap, createCell, rows, cols),
        _rows = rows,
        _cols = cols,
        _onTap = onTap,
        _createCell = createCell,
        super(key: key);

  int get x => _zoneGridState.x;

  int get y => _zoneGridState.y;

  bool get hasSelected => _zoneGridState.hasSelected;

  @override
  _ZoneGridState createState() {
    _zoneGridState = _ZoneGridState(_onTap, _createCell, _rows, _cols);
    return _zoneGridState;
  }
}

class _ZoneGridState extends State<ZoneGrid> {
  int _selectedX = 0, _selectedY = 0;
  bool _hasSelected = false;
  int _rows, _cols;

  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;

  _ZoneGridState(this._onTap, this._createCell, this._rows, this._cols);

  @override
  void initState() {
    super.initState();
  }

  int get x => _selectedX;

  int get y => _selectedY;

  bool get hasSelected => _hasSelected;

  List<TableRow> _getTableContents(double width, double height) {
    List<TableRow> tableRows = [];
    final double cellWidth = width / _cols, cellHeight = height / _rows;

    for (int i = 0; i < _rows; i++) {
      List<Widget> row = [];
      for (int j = 0; j < _cols; j++) {
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
