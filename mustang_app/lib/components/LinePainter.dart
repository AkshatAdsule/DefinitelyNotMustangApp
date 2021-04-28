import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  double x, y, x2, y2;

  LinePainter(this.x, this.y, this.x2, this.y2);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green;
    paint.strokeWidth = 10;

    canvas.drawLine(
      Offset(x, y),
      Offset(x2, y2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
