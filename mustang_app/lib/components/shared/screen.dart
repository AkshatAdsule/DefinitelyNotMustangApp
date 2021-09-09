import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/bottom_nav_bar.dart';
import 'package:mustang_app/components/shared/header.dart';
import 'package:mustang_app/components/shared/nav_drawer.dart';

// ignore: must_be_immutable
class Screen extends StatelessWidget {
  Widget child, floatingActionButton;
  String title;
  List<Widget> headerButtons;
  bool includeHeader, includeBottomNav;
  bool left, right, top, bottom;
  static NavDrawer drawer = NavDrawer();
  Key key;
  Color color;

  Screen({
    this.child,
    this.title,
    this.headerButtons,
    this.includeHeader = true,
    this.includeBottomNav = false,
    this.left = true,
    this.right = true,
    this.top = true,
    this.bottom = true,
    this.floatingActionButton,
    this.key,
    this.color,
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
      body: Container(
        color: this.color ?? Theme.of(context).canvasColor,
        child: SafeArea(
          bottom: bottom,
          top: top,
          left: left,
          right: right,
          child: Container(
            child: child,
            key: key,
          ),
        ),
      ),
      drawer: drawer,
      bottomNavigationBar: includeBottomNav
          ? BottomNavBar(
              context,
            )
          : null,
      resizeToAvoidBottomInset: false,
    );
  }
}
