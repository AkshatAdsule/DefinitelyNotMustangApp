import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';

class Header extends AppBar {
  Header(BuildContext context, String text, {List<Widget> buttons})
      : super(
          title: Text(text),
          actions: <Widget>[
            buttons == null
                ? Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                        BottomNavBar.setSelected('/');
                      },
                    ))
                : Row(
                    children: buttons,
                  )
          ],
        );
}
