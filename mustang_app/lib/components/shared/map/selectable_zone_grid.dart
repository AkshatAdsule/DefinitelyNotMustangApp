import 'package:flutter/material.dart';
import './zone_grid.dart';

// ignore: must_be_immutable
class SelectableZoneGrid extends ZoneGrid {
  SelectableZoneGrid(Key key, Function(int x, int y) onTap,
      {bool multiSelect = false,
      AnimationType type = AnimationType.TRANSLATE,
      List<Widget> Function(BoxConstraints constraints, List<Offset> selections,
              double cellWidth, double cellHeight)
          createOverlay})
      : super(
          key,
          onTap,
          (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: isSelected && type != AnimationType.TRANSLATE
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
              key: Key("($x,$y)"),
              height: cellHeight,
              width: cellWidth,
            );
          },
          type: type,
          multiSelect: multiSelect,
          createOverlay: createOverlay,
        );
}
