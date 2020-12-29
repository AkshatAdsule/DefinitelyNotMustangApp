import 'package:flutter/material.dart';

class GameMap extends StatelessWidget {
  List<Widget> _imageChildren = [], _columnChildren = [];
  GameMap({List<Widget> imageChildren, List<Widget> columnChildren}) {
    _imageChildren.add(Image.asset('assets/croppedmap.png'));
    _imageChildren.add(GameMapChild(
      align: Alignment.center,
      child: RaisedButton(
        child: Text('Hello'),
        onPressed: () {},
      ),
    ));

    // _imageChildren.addAll(imageChildren);
    _columnChildren.addAll(columnChildren);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
          child: Stack(children: _imageChildren),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: Column(
            children: _columnChildren,
          ),
        )
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
