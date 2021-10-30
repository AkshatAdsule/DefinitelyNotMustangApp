import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/shared/logo.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/pages/data-collection-analysis/data_view.dart';
import 'package:mustang_app/pages/home.dart';
import 'package:mustang_app/pages/pre_event_analysis/input_screen.dart';
import 'package:mustang_app/pages/profile.dart';
import 'package:mustang_app/pages/scouting/scouter.dart';
import 'package:mustang_app/pages/analysis/search.dart';
import 'package:mustang_app/pages/glossary.dart';
import 'package:mustang_app/pages/sketcher.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  static const List<Map<String, dynamic>> routes = [
    {
      'route': Home.route,
      'icon': Icons.home,
      'name': 'Home',
    },
    {
      'route': Scouter.route,
      'icon': Icons.list,
      'name': 'Scouter',
    },
    {
      'route': InputScreen.route,
      'icon': Icons.insert_chart_outlined,
      'name': 'Pre Event Analysis',
    },
    {
      'route': SearchPage.route,
      'icon': Icons.search,
      'name': 'Team Data',
    },
    // {
    //   'route': DataViewScreen.route,
    //   'icon': Icons.dashboard_outlined,
    //   'name': '670 Analysis',
    // },
    {
      'route': SketchPage.route,
      'icon': Icons.edit,
      'name': 'Draw',
    },
    {
      'route': Glossary.route,
      'icon': Icons.account_tree,
      'name': 'Glossary',
    },
  ];
  int _selectedIndex;

  NavDrawer() {
    _selectedIndex = 0;
  }

  void setSelected(String route) {
    _selectedIndex = routes.indexWhere((element) => element['route'] == route);
  }

  void navigate(BuildContext context, String route) {
    setSelected(route);

    Navigator.of(context).pushNamed(route);
  }

  int get selected => _selectedIndex;
  String get selectedRoute => routes[_selectedIndex]['route'];

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context) ??
        UserModel(
          firstName: "Horse",
          lastName: "Head",
          email: "horseybusiness@gmail.com",
          uid: "",
          userType: UserType.MEMBER,
          teamNumber: "670",
          teamStatus: TeamStatus.JOINED,
        );

    List<NavItem> items = [];
    for (int i = 0; i < routes.length; i++) {
      Map<String, dynamic> curr = routes.elementAt(i);
      items.add(NavItem(
        _selectedIndex == i,
        curr['name'],
        curr['icon'],
        () {
          navigate(context, curr['route']);
        },
      ));
    }
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            // GestureDetector(
            //   onTap: () => Navigator.of(context).pushNamed(Profile.route),
            //   child: DrawerHeader(
            //     padding: EdgeInsets.only(left: 30, top: 10),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //           padding: EdgeInsets.all(10),
            //           width: 100,
            //           height: 100,
            //           child: Image.network(
            //             AuthService.currentUser?.photoURL ??
            //                 'https://firebasestorage.googleapis.com/v0/b/mustangapp-b1398.appspot.com/o/logo.png?alt=media&token=f45e368d-3cba-4d67-b8d5-2e554f87e046',
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.only(top: 10, left: 10),
            //           child: Text(
            //             "${user.firstName} ${user.lastName}",
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //     ),
            //   ),
            // ),
            ...items,
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final bool _selected;
  final String _text;
  final IconData _leading;

  final void Function() _onTap;
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
