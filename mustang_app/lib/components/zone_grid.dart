import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

enum AnimationType { TRANSLATE, FADE }

// ignore: must_be_immutable
class ZoneGrid extends StatefulWidget {
  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;
  List<Widget> Function(BoxConstraints constraints, List<Offset> selections,
      double cellWidth, double cellHeight) _createOverlay;
  int _rows, _cols;
  bool _multiSelect;
  AnimationType _type;

  ZoneGrid(
      Key key,
      Function(int x, int y) onTap,
      Widget Function(int x, int y, bool isSelected, double cellWidth,
              double cellHeight)
          createCell,
      {int rows = Constants.zoneRows,
      int cols = Constants.zoneColumns,
      bool multiSelect = false,
      AnimationType type = AnimationType.TRANSLATE,
      List<Widget> Function(BoxConstraints constraints, List<Offset> selections,
              double cellWidth, double cellHeight)
          createOverlay})
      : super(key: key) {
    _rows = rows;
    _cols = cols;
    _onTap = onTap;
    _createCell = createCell;
    _multiSelect = multiSelect;
    _type = type;
    _createOverlay = createOverlay;
  }

  @override
  ZoneGridState createState() {
    return ZoneGridState(
        _onTap, _createCell, _rows, _cols, _multiSelect, _type, _createOverlay);
  }
}

class ZoneGridState extends State<ZoneGrid> {
  int _selectedX = 0, _selectedY = 0;
  int _rows, _cols;
  Widget overlay;
  List<List<bool>> _selected;
  List<Offset> _selections;
  bool _multiSelect;
  Function(int x, int y) _onTap;
  AnimationType _type;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;

  List<Widget> Function(BoxConstraints constraints, List<Offset> selections,
      double cellWidth, double cellHeight) _createOverlay;

  ZoneGridState(this._onTap, this._createCell, this._rows, this._cols,
      this._multiSelect, this._type, this._createOverlay);

  @override
  void initState() {
    super.initState();
    _selections = [];
    _selected = List.generate(
      _rows,
      (index) => List.generate(
        _cols,
        (index) => false,
      ),
    );
  }

  int get x => _selectedX;

  int get y => _selectedY;

  bool get hasSelected => _selected.any((element) => element.contains(true));

  int get numSelected {
    int counter = 0;
    _selected.forEach((element) {
      element.forEach((element) {
        if (element) {
          counter++;
        }
      });
    });
    return counter;
  }

  List<Offset> get selections => _selections;

  void clearSelections() {
    if (_selections.length > 0) {
      _selected = List.generate(
        _rows,
        (y) => List.generate(
          _cols,
          (x) => _selections.last.dy.toInt() == y && _selections.last.dx == x,
        ),
      );
      _selections = [_selections.last];
    }
  }

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
                setState(() {
                  if (_selected[i][j]) {
                    _selections.removeWhere((element) =>
                        element.dx.toInt() == j && element.dy.toInt() == j);
                  } else {
                    _selections.add(Offset(j.toDouble(), i.toDouble()));
                  }
                  _selected[i][j] = !_selected[i][j];
                  if (_selectedX != j || _selectedY != i) {
                    _selected[_selectedY][_selectedX] =
                        _multiSelect ? true : false;
                  }
                  _selectedX = j;
                  _selectedY = i;
                });
                _onTap(j, i);
              },
              child: _createCell(j, i, _selected[i][j], cellWidth, cellHeight),
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
          return Stack(
            children: [
              Table(
                defaultColumnWidth: IntrinsicColumnWidth(),
                children: _getTableContents(
                    constraints.maxWidth, constraints.maxHeight),
              ),
              ...(_createOverlay != null
                  ? _createOverlay(
                      constraints,
                      _selections,
                      constraints.maxWidth / _cols,
                      constraints.maxHeight / _rows)
                  : [])
            ],
          );
        },
      ),
    );
  }
}
