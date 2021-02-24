import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

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
