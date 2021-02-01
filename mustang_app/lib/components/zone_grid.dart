import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class ZoneGrid extends StatefulWidget {
  static _ZoneGridState _zoneGridState;

  ZoneGrid(Function(int x, int y) onTap) {
    _zoneGridState = _ZoneGridState(onTap);
  }

  static int get x {
    return _zoneGridState.x;
  }

  static int get y {
    return _zoneGridState.y;
  }

  @override
  _ZoneGridState createState() => _zoneGridState;
}

class _ZoneGridState extends State<ZoneGrid> {
  int _selectedX = 0, _selectedY = 0;
  bool _hasSelected;

  //TODO: fix x,y
  Function(int x, int y) _onTap;
  _ZoneGridState(this._onTap);

  @override
  void initState() {
    super.initState();
    _hasSelected = false;
  }

  int get x {
    return _selectedX;
  }

  int get y {
    return _selectedY;
  }

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
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: _hasSelected && _selectedX == j && _selectedY == i
                        ? RadialGradient(
                            // center: ,
                            // begin: Alignment.bottomLeft,
                            // end: Alignment.topRight,
                            colors: [
                                Colors.green,
                                Colors.green, //.withOpacity(0.9),
                                Colors.lightGreenAccent.withOpacity(0.9),
                              ])
                        : null),
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
            children:
                _getTableContents(constraints.maxWidth, constraints.maxHeight),
          );
        },
      ),
    );
  }
}
