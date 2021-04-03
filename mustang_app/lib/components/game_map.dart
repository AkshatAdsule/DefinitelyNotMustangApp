import 'package:flutter/material.dart';
import 'package:mustang_app/components/zone_grid.dart';

// ignore: must_be_immutable
class GameMap extends StatelessWidget {
  List<Widget> _imageChildren = [];
  Widget _sideWidget;
  String _allianceColor;
  bool _offenseOnRightSide;
  
  ZoneGrid _zoneGrid;

  GameMap({
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
  }

  @override
  Widget build(BuildContext context) {
    String imageName = '';
      if (_allianceColor.toUpperCase() == "BLUE" && _offenseOnRightSide == true){
        debugPrint("right blue, left red");
        imageName = 'assets/rightblue_leftred.png';
      }
      else if (_allianceColor.toUpperCase() == "BLUE" && _offenseOnRightSide == false){
                debugPrint("right red, left blue");

        imageName = 'assets/rightred_leftblue.png';
      }
      else if (_allianceColor.toUpperCase() == "RED" && _offenseOnRightSide == true){
                       debugPrint("right red, left blue");

        imageName = 'assets/rightred_leftblue.png';
      }
      else if (_allianceColor.toUpperCase() == "RED" && _offenseOnRightSide == false){
        debugPrint("right blue, left red");
        imageName = 'assets/rightblue_leftred.png';
      }

    return Container(
        child: Row(
      children: [
        Flexible(
          flex: 7,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(imageName),
              /*
              Image.asset(_allianceColor.toUpperCase() == "BLUE"
                  ? 'assets/blue_field.png'
                  : 'assets/red_field.png'),
                  */
              _zoneGrid ?? Container(),
              ..._imageChildren,
            ],
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
    return Align(
      alignment: align,
      child: child,
    );
  }
}
