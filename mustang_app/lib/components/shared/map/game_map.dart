import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import './zone_grid.dart';

// ignore: must_be_immutable
class GameMap extends StatelessWidget {
  List<Widget> _imageChildren = [];
  Widget _sideWidget;
  String _allianceColor;
  bool _offenseOnRightSide;
  Stopwatch _stopwatch;
  ZoneGrid _zoneGrid;

  GameMap({
    Stopwatch stopwatch,
    List<Widget> imageChildren = const [],
    Widget sideWidget,
    ZoneGrid zoneGrid,
    String allianceColor = "blue",
    bool offenseOnRightSide = false,
  }) {
    _imageChildren.addAll(imageChildren);
    _sideWidget = sideWidget;
    _zoneGrid = zoneGrid;
    _allianceColor = allianceColor;
    _offenseOnRightSide = offenseOnRightSide;
    _stopwatch = stopwatch;
  }

  @override
  Widget build(BuildContext context) {
    String imageName = '';
    if (_allianceColor.toUpperCase() == "BLUE" && _offenseOnRightSide == true) {
      imageName = 'assets/rightblue_leftred.png';
    } else if (_allianceColor.toUpperCase() == "BLUE" &&
        _offenseOnRightSide == false) {
      imageName = 'assets/rightred_leftblue.png';
    } else if (_allianceColor.toUpperCase() == "RED" &&
        _offenseOnRightSide == true) {
      imageName = 'assets/rightred_leftblue.png';
    } else if (_allianceColor.toUpperCase() == "RED" &&
        _offenseOnRightSide == false) {
      imageName = 'assets/rightblue_leftred.png';
    }
    //1159 width 604 height
    Image image = Image.asset(imageName);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image);
        },
      ),
    );

    return Container(
        child: Row(
      children: [
        Flexible(
          flex: 7,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FutureBuilder<ui.Image>(
                future: completer.future,
                builder:
                    (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                  //Default dimensions of the asset image
                  double width = 1159, height = 604;
                  if (snapshot.hasData) {
                    width = snapshot.data.width.toDouble();
                    height = snapshot.data.height.toDouble();
                  }
                  return Container(
                    height: (height * constraints.maxWidth) / width + 1,
                    child: Container(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Image.asset(
                            imageName,
                            fit: BoxFit.fitWidth,
                          ),
                          _zoneGrid ?? Container(),
                          ..._imageChildren,
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Flexible(
          child: _sideWidget ?? Container(),
          flex: _sideWidget != null ? 3 : 0,
        ),
      ],
    ));
  }
}

// ignore: must_be_immutable
class GameMapChild extends StatelessWidget {
  Widget child;
  AlignmentGeometry align;
  double top = 0.0, bottom = 0.0, left = 0.0, right = 0.0;

  GameMapChild({
    this.child,
    this.align,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 5000),
      alignment: align,
      child: child,
    );
  }
}
