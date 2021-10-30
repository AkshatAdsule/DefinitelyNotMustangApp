import 'dart:ui';

import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  List<Offset> points;
  final Animation<double> animation;
  bool shouldAnimate;

  PathPainter(this.points, {this.shouldAnimate = false, this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 5;
    Path path = new Path();
    path.moveTo(points.first.dx, points.first.dy);

    points.sublist(1).forEach((element) {
      path.lineTo(element.dx, element.dy);
    });
    canvas.drawPath(
        shouldAnimate ? createAnimatedPath(path, animation.value) : path,
        paint);
  }

  Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return shouldAnimate;
  }
}
