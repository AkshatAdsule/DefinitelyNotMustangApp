import 'package:flutter/material.dart';
import 'package:mustang_app/pages/pre-event-analysis/inputScreen.dart';
import '../pages/sketcher.dart';
import '../pages/calendar.dart';
import '../pages/scouting/scouter.dart';
import '../pages/search.dart';

class BottomNavBar extends BottomNavigationBar {
  static int _selectedIndex = 0;

  static final routes = [
    '/',
    Calendar.route,
    Scouter.route,
    InputScreen.route,
    SearchPage.route,
    SketchPage.route,
  ];

  static void setSelected(String route) {
    _selectedIndex = routes.indexOf(route);
  }

  BottomNavBar(BuildContext context)
      : super(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Scouter',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart_outlined), label: 'Analysis'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Draw',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: (int index) {
            _selectedIndex = index;
            Navigator.of(context).pushNamed('/');
            Navigator.of(context).pushNamed(routes[index]);
          },
        );
}
