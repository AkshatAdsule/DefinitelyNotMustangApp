import 'package:flutter/material.dart';
import 'package:mustang_app/components/selectable_zone_grid.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';

import 'animated_push_line.dart';

class MovingRobot extends StatelessWidget {
  final double cellWidth, cellHeight, x, y;

  MovingRobot(
    this.x,
    this.y,
    this.cellWidth,
    this.cellHeight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: AnimatedPositioned(
      child: Container(
        width: cellWidth,
        height: cellHeight,
        child: Image.asset('assets/bb8.gif'),
      ),
      left: cellWidth * x,
      top: cellHeight * y,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1000),
    ));
  }
}

class ScoutingZoneGrid extends SelectableZoneGrid {
  ScoutingZoneGrid({
    GlobalKey<ZoneGridState> zoneGridKey,
    GlobalKey<MapScoutingState> mapScoutingKey,
    GlobalKey<AnimatedPushLineState> pushLineKey,
  }) : super(
          zoneGridKey,
          (int x, int y) {
            if (x != mapScoutingKey.currentState.prevX ||
                y != mapScoutingKey.currentState.prevY) {
              mapScoutingKey.currentState.onZoneGridTap(x, y);
            }
            if (mapScoutingKey.currentState.pushTextStart) {
              zoneGridKey.currentState.clearSelections();
              pushLineKey.currentState.startAnimation();
            }
          },
          type: AnimationType.TRANSLATE,
          multiSelect: true,
          createOverlay: (BoxConstraints constraints, List<Offset> selections,
              double cellWidth, double cellHeight) {
            if (selections.length == 0) {
              return [];
            }

            List<Offset> newPoints = [
              Offset(
                cellWidth * mapScoutingKey.currentState.pushStartX +
                    cellWidth / 2,
                cellHeight * mapScoutingKey.currentState.pushStartY +
                    cellHeight / 2,
              ),
              Offset(
                cellWidth * selections.last.dx + cellWidth / 2,
                cellHeight * selections.last.dy + cellHeight / 2,
              ),
            ];

            if (pushLineKey.currentState != null &&
                pushLineKey.currentState.points != newPoints) {
              if (pushLineKey.currentState.points.first !=
                  pushLineKey.currentState.points.last) {
                pushLineKey.currentState.reverse().then((val) {
                  if (pushLineKey.currentState != null) {
                    pushLineKey.currentState.setPoints(newPoints);
                    pushLineKey.currentState.startAnimation();
                  }
                });
              } else {
                pushLineKey.currentState.setPoints(newPoints);
              }
            }
            if (mapScoutingKey.currentState.pushTextStart) {
              return [
                AnimatedPushLine(
                  key: pushLineKey,
                  points: [
                    Offset(
                      cellWidth * mapScoutingKey.currentState.pushStartX +
                          cellWidth / 2,
                      cellHeight * mapScoutingKey.currentState.pushStartY +
                          cellHeight / 2,
                    ),
                    Offset(
                      cellWidth * selections.last.dx + cellWidth / 2,
                      cellHeight * selections.last.dy + cellHeight / 2,
                    ),
                  ],
                ),
                PushStartPoint(
                  mapScoutingKey.currentState.pushStartX,
                  mapScoutingKey.currentState.pushStartY,
                  cellWidth,
                  cellHeight,
                ),
                MovingRobot(
                  selections.last.dx,
                  selections.last.dy,
                  cellWidth,
                  cellHeight,
                ),
              ];
            } else {
              return [
                MovingRobot(
                  selections.last.dx,
                  selections.last.dy,
                  cellWidth,
                  cellHeight,
                ),
              ];
            }
          },
        );
}
