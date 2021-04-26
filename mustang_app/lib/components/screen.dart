import 'package:flutter/material.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/nav_drawer.dart';

// ignore: must_be_immutable
class Screen extends StatelessWidget {
  Widget child, floatingActionButton;
  String title;
  List<Widget> headerButtons;
  bool includeHeader, includeBottomNav;
  bool left, right, top, bottom;
  static NavDrawer drawer = NavDrawer();

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
      drawer: drawer,
      bottomNavigationBar: includeBottomNav
          ? BottomNavBar(
              context,
            )
          : null,
    );
  }
}
