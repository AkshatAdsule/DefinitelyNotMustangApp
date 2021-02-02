import 'package:flutter/material.dart';
import './zone_grid.dart';

class SelectableZoneGrid extends ZoneGrid {
  SelectableZoneGrid(Key key, Function(int x, int y) onTap)
      : super(key, onTap, (int x, int y, bool isSelected, double cellWidth,
            double cellHeight) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isSelected
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
            key: Key("($x,$y)"),
            height: cellHeight,
            width: cellWidth,
          );
        });
}
