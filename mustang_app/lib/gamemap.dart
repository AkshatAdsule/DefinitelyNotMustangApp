import 'package:flutter/material.dart';

class GameMap extends StatelessWidget {
  List<Widget> _children;
  GameMap({List<Widget> children}) {
    _children = [];
    _children.add(Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/croppedmap.png'),
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft)),
    ));
    if (children != null) _children.addAll(children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Container(
          child: Stack(
            children: [
              Image.asset('assets/croppedmap.png'),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child:
                        RaisedButton(onPressed: () {}, child: Text('Hello'))),
              )
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              RaisedButton(onPressed: () {}, child: Text('Offense')),
              RaisedButton(onPressed: () {}, child: Text('Inner')),
              RaisedButton(onPressed: () {}, child: Text('Inner')),
              RaisedButton(onPressed: () {}, child: Text('Inner'))
            ],
          ),
        )
      ],
    ));
  }
}
