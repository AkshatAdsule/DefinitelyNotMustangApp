import 'package:flutter/material.dart';

class GameMap extends StatelessWidget {
  List<Widget> _children;
  GameMap({List<Widget> children}) {
    _children = [];
    _children.add(Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/croppedmap.png'), fit: BoxFit.contain)),
    ));
    if (children != null) _children.addAll(children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: _children,
      ),
    );
  }
}
