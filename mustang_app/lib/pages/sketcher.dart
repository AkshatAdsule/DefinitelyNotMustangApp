import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/exports/pages.dart';

class SketchPage extends StatefulWidget {
  static const String route = './Sketcher';

  @override
  _SketchPageState createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    return Screen(
      includeBottomNav: false,
      includeHeader: false,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(
            () {
              RenderBox renderBox = context.findRenderObject();
              points.add(
                DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth,
                ),
              );
            },
          );
        },
        onPanStart: (details) {
          setState(
            () {
              RenderBox renderBox = context.findRenderObject();
              points.add(
                DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth,
                ),
              );
            },
          );
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                'assets/rightblue_leftred.png',
              ),
            ),
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: points,
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green.shade800,
        children: [
          SpeedDialChild(
            label: 'Clear Screen',
            backgroundColor: Colors.green,
            child: Icon(Icons.refresh),
            onTap: () {
              setState(() => points.clear());
            },
          ),
          SpeedDialChild(
            label: 'Palette',
            backgroundColor: Colors.green,
            child: Icon(Icons.format_paint),
            onTap: () {
              showColorPicker();
            },
          ),
          SpeedDialChild(
            label: 'Exit',
            backgroundColor: Colors.green,
            child: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pushNamed(context, HomePage.route);
            },
          ),
        ],
      ),
    );
  }

  showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              pickerColor = color;
            },
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              setState(() => selectedColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}
