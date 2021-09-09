import 'package:flutter/material.dart';
import 'package:mustang_app/pages/data-collection-analysis/data_view.dart';
import 'package:mustang_app/pages/home.dart';
import 'package:mustang_app/pages/pre_event_analysis/input_screen.dart';
import '../../pages/sketcher.dart';
import '../../pages/scouting/scouter.dart';
import '../../pages/analysis/search.dart';
import '../../pages/glossary.dart';

class BottomNavBar extends BottomNavigationBar {
  static int _selectedIndex = 0;

  static final routes = [
    Home.route,
    // Calendar.route,
    Scouter.route,
    InputScreen.route,
    SearchPage.route,
    Glossary.route,
    DataViewScreen.route,
    SketchPage.route,
  ];

  static void setSelected(String route) {
    _selectedIndex = routes.indexOf(route);
  }

  static int get selected => _selectedIndex;
  static String get selectedRoute => routes[_selectedIndex];

  BottomNavBar(BuildContext context)
      : super(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today),
            //   label: 'Calendar',
            // ),
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
              icon: Icon(Icons.account_tree),
              label: 'Links',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Data Collection Analysis',
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
            Navigator.of(context).pushReplacementNamed(routes[index]);
          },
        );
}
