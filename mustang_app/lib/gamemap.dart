import 'package:flutter/material.dart';

class GameMap extends StatelessWidget {
  List<Widget> _imageChildren = [], _columnChildren = [];
  GameMap({List<Widget> imageChildren, List<Widget> columnChildren}) {
    _imageChildren.add(Image.asset('assets/croppedmap.png'));
    _imageChildren.addAll(imageChildren);
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
