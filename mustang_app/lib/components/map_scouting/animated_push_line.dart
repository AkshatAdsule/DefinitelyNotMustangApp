import 'package:flutter/material.dart';
import 'package:mustang_app/components/map_scouting/path_painter.dart';

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
  List<Offset> points, oldPoints;

  AnimatedPushLineState({
    @required this.points,
  }) {
    oldPoints = [];
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setPoints(List<Offset> newPoints) {
    setState(() {
      points = newPoints;
    });
  }

  Future<void> reverse() async {
    _controller.duration = Duration(milliseconds: 400);
    return _controller.reverse(from: 1.0).then((value) {});
  }

  void startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward();
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
