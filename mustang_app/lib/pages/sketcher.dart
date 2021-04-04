import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mustang_app/components/screen.dart';

class SketchPage extends StatefulWidget {
  static const String route = './Sketcher';

  @override
  _SketchPageState createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  List<Offset> points = <Offset>[];
  Sketcher _sketcher;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  _SketchPageState() {
    _sketcher = new Sketcher(points);
  }
// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

// raise the [showDialog] widget
  void showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              enableLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  currentColor = pickerColor;
                  _sketcher.setColor(currentColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // takescrshot() async {
  //   RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
  //   var image = await boundary.toImage();
  //   var byteData = await image.toByteData(format: ImageByteFormat.png);
  //   var pngBytes = byteData.buffer.asUint8List();
  //   print(pngBytes);
  // }

  // var scr = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/rightblue_leftred.png"),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      child: CustomPaint(
        painter: _sketcher,
      ),
    );

    // return RepaintBoundary(
    //     key: scr,
    //     child:
    return Screen(
      includeBottomNav: false,
      includeHeader: false,
      top: false,
      bottom: false,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height));

            points = List.from(points)..add(point);
            _sketcher = new Sketcher(points);
            _sketcher.setColor(currentColor);
          });
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
        },
        child: sketchArea,
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
              }),
          SpeedDialChild(
              label: 'Take picture',
              backgroundColor: Colors.green,
              child: Icon(Icons.camera),
              onTap: () {
                // takescrshot();
              })
        ],
      ),
      // )
    );
  }
}

class Sketcher extends CustomPainter {
  final List<Offset> points;
  Color _color = Colors.black;
  Sketcher(this.points);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  void setColor(Color color) {
    _color = color;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}
