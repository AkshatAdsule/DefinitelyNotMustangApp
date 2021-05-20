import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/logo.dart';
import 'package:mustang_app/pages/home.dart';
import 'package:mustang_app/pages/pre_event_analysis/input_screen.dart';
import 'package:mustang_app/pages/scouting/scouter.dart';
import 'package:mustang_app/pages/analysis/search.dart';
import 'package:mustang_app/pages/glossary.dart';
import 'package:mustang_app/pages/sketcher.dart';

class NavDrawer extends StatelessWidget {
  static const routes = [
    Home.route,
    // Calendar.route,
    Scouter.route,
    InputScreen.route,
    SearchPage.route,
    Glossary.route,
    SketchPage.route,
  ];
  int _selectedIndex;

  NavDrawer() {
    _selectedIndex = 0;
  }

  void setSelected(String route) {
    _selectedIndex = routes.indexOf(route);
  }

  void navigate(BuildContext context, String route) {
    setSelected(route);

    Navigator.of(context).pushNamed(route);
  }

  int get selected => _selectedIndex;
  String get selectedRoute => routes[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Logo(
                70,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          NavItem(
            _selectedIndex == 0,
            'Home',
            Icons.home,
            () {
              navigate(context, Home.route);
            },
          ),
          NavItem(
            _selectedIndex == 1,
            'Scouter',
            Icons.list,
            () {
              navigate(context, Scouter.route);
            },
          ),
          NavItem(
            _selectedIndex == 2,
            'Pre Event Analysis',
            Icons.insert_chart_outlined,
            () {
              navigate(context, InputScreen.route);
            },
          ),
          NavItem(
            _selectedIndex == 3,
            'Team Data',
            Icons.search,
            () {
              navigate(context, SearchPage.route);
            },
          ),
          NavItem(
            _selectedIndex == 4,
            'Glossary',
            Icons.account_tree,
            () {
              navigate(context, Glossary.route);
            },
          ),
          NavItem(
            _selectedIndex == 5,
            'Draw',
            Icons.edit,
            () {
              navigate(context, SketchPage.route);
            },
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  bool _selected;
  String _text;
  IconData _leading;
  void Function() _onTap;
  NavItem(
    this._selected,
    this._text,
    this._leading,
    this._onTap,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {},
      child: ListTile(
        leading: Icon(
          _leading,
          color: _selected ? Colors.white : Colors.green,
        ),
        title: Text(
          _text,
          style: TextStyle(
            color: _selected ? Colors.white : Colors.green,
          ),
        ),
        tileColor: _selected ? Colors.green : Colors.white,
        onTap: () {
          _onTap();
        },
      ),
    );
  }
}
