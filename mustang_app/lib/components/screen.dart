import 'package:flutter/material.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import 'package:mustang_app/components/header.dart';

class Screen extends StatelessWidget {
  Widget child, floatingActionButton;
  String title;
  List<Widget> headerButtons;
  bool includeHeader, includeBottomNav;
  bool left, right, top, bottom;

  Screen({
    this.child,
    this.title,
    this.headerButtons,
    this.includeHeader = true,
    this.includeBottomNav = true,
    this.left = true,
    this.right = true,
    this.top = true,
    this.bottom = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: includeHeader
          ? Header(
              context,
              title,
              buttons: headerButtons ?? [],
            )
          : null,
      body: SafeArea(
        bottom: bottom,
        top: top,
        left: left,
        right: right,
        key: UniqueKey(),
        child: child,
      ),
      bottomNavigationBar: includeBottomNav
          ? BottomNavBar(
              context,
            )
          : null,
    );
  }
}
