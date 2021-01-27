import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class GameMap extends StatelessWidget {
  List<Widget> _imageChildren = [], _sideWidgets;
  GameMap(
      {List<Widget> imageChildren = const [],
      List<Widget> sideWidgets = const []}) {
    if (Constants.fieldColor == 0) {
      _imageChildren.add(Image.asset('assets/blue_field.png'));
    } else if (Constants.fieldColor == 1) {
      _imageChildren.add(Image.asset('assets/red_field.png'));
    }
    //_imageChildren.add(Image.asset('assets/croppedmap.png'));
    _imageChildren.addAll(imageChildren);
    _sideWidgets = sideWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
          child: Stack(fit: StackFit.expand, children: [
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                child: GridView.count(
                  childAspectRatio: 0.5,
                  crossAxisCount: 16,
                  children: List.generate(
                    8 * 16,
                    (index) => Container(
                      child: Center(),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
              ),
            ),
            ..._imageChildren
          ]),
        ),
        ..._sideWidgets
      ],
    ));
  }
}

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
    return Positioned.fill(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        child: Align(
          alignment: align,
          child: child,
        ));
  }
}
