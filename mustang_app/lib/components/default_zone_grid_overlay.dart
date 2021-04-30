import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';

import 'path_painter.dart';

class AnimatedPushLine extends StatefulWidget {
  final List<Offset> points;

  AnimatedPushLine({Key key, @required this.points}) : super(key: key);

  @override
  AnimatedPushLineState createState() => AnimatedPushLineState(points: points);
}

class AnimatedPushLineState extends State<AnimatedPushLine>
    with TickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _animation;
  List<Offset> points;

  AnimatedPushLineState({
    @required this.points,
  });

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setPoints(List<Offset> newPoints) {
    setState(() {
      points = newPoints;
    });
  }

  void startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward();
  }

  void selectNewLocation(List<Offset> newPoints) {
    _controller.reverse().then((value) {
      setState(() {
        points = newPoints;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(
        points,
        shouldAnimate: true,
        animation: _animation,
      ),
    );
  }
}

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

class PushStartPoint extends StatelessWidget {
  final double cellWidth, cellHeight;
  final int x, y;

  PushStartPoint(
    this.x,
    this.y,
    this.cellWidth,
    this.cellHeight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedPositioned(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 1000),
        left: cellWidth * x,
        top: cellHeight * y,
        child: Container(
          width: cellWidth,
          height: cellHeight,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.lightGreenAccent.withOpacity(0.9),
                    Colors.green,
                  ],
                ),
              ),
              width: 15,
              height: 15,
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> defaultOverlay(
  BoxConstraints constraints,
  List<Offset> selections,
  double cellWidth,
  double cellHeight,
  GlobalKey<ZoneGridState> zoneGridKey,
  GlobalKey<MapScoutingState> mapScoutingKey,
  GlobalKey<AnimatedPushLineState> pushLineKey, {
  List<Widget> children = const [],
}) {
  if (selections.length == 0) {
    return [];
  }

  List<Offset> newPoints = [
    Offset(
      cellWidth * mapScoutingKey.currentState.pushStartX + cellWidth / 2,
      cellHeight * mapScoutingKey.currentState.pushStartY + cellHeight / 2,
    ),
    Offset(
      cellWidth * selections.last.dx + cellWidth / 2,
      cellHeight * selections.last.dy + cellHeight / 2,
    ),
  ];

  if (pushLineKey.currentState != null &&
      pushLineKey.currentState.points != newPoints) {
    pushLineKey.currentState.setPoints(newPoints);
  }
  if (mapScoutingKey.currentState.pushTextStart) {
    return [
      AnimatedPushLine(
        key: pushLineKey,
        points: [
          Offset(
            cellWidth * mapScoutingKey.currentState.pushStartX + cellWidth / 2,
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
      ...children,
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
}
