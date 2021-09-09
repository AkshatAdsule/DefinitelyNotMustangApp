import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Badge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const Badge({
    Key key,
    this.icon = FontAwesomeIcons.medal,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }
}
