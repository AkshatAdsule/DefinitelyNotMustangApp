import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

enum AnimationType { TRANSLATE, FADE }

// ignore: must_be_immutable
class ZoneGrid extends StatefulWidget {
  _ZoneGridState _zoneGridState;
  Function(int x, int y) _onTap;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;
  int _rows, _cols;
  bool _multiSelect;
  AnimationType _type;

  ZoneGrid(
    Key key,
    Function(int x, int y) onTap,
    Widget Function(
            int x, int y, bool isSelected, double cellWidth, double cellHeight)
        createCell, {
    int rows = Constants.zoneRows,
    int cols = Constants.zoneColumns,
    bool multiSelect = false,
    AnimationType type = AnimationType.TRANSLATE,
  })  : _zoneGridState =
            _ZoneGridState(onTap, createCell, rows, cols, multiSelect, type),
        _rows = rows,
        _cols = cols,
        _onTap = onTap,
        _createCell = createCell,
        _multiSelect = multiSelect,
        _type = type,
        super(key: key);

  int get x => _zoneGridState.x;

  int get y => _zoneGridState.y;

  bool get hasSelected => _zoneGridState.hasSelected;

  int get numSelected => _zoneGridState.numSelected;

  @override
  _ZoneGridState createState() {
    _zoneGridState =
        _ZoneGridState(_onTap, _createCell, _rows, _cols, _multiSelect, _type);
    return _zoneGridState;
  }
}

class _ZoneGridState extends State<ZoneGrid> {
  int _selectedX = 0, _selectedY = 0;
  int _rows, _cols;
  Widget overlay;
  List<List<bool>> _selected;
  bool _multiSelect;
  Function(int x, int y) _onTap;
  AnimationType _type;
  Widget Function(
          int x, int y, bool isSelected, double cellWidth, double cellHeight)
      _createCell;

  _ZoneGridState(this._onTap, this._createCell, this._rows, this._cols,
      this._multiSelect, this._type);

  @override
  void initState() {
    super.initState();
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
                  _selected[i][j] = !_selected[i][j];
                  if (_selectedX != j || _selectedY != i) {
                    _selected[_selectedY][_selectedX] =
                        _multiSelect ? true : false;
                  }
                  _selectedX = j;
                  _selectedY = i;
                });
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
    double height = 2 / _rows, width = 2 / _cols;
    double x = _selectedX * width - 1, y = (_selectedY) * height - 1;
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
              _type.index == AnimationType.TRANSLATE.index && hasSelected
                  ? AnimatedPositioned(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: _selected[_selectedY][_selectedX] &&
                                    _type != AnimationType.TRANSLATE
                                ? RadialGradient(
                                    // center: ,
                                    // begin: Alignment.bottomLeft,
                                    // end: Alignment.topRight,
                                    colors: [
                                      Colors.green,
                                      Colors.green, //.withOpacity(0.9),
                                      Colors.lightGreenAccent.withOpacity(0.9),
                                    ],
                                  )
                                : null),
                        width: constraints.maxWidth / _cols,
                        height: constraints.maxHeight / _rows,
                        child: Image.asset('assets/bb8.gif'),
                      ),
                      left: constraints.maxWidth / _cols * _selectedX,
                      top: constraints.maxHeight / _rows * _selectedY,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 1000),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }
}
