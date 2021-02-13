import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/bottom_nav_bar.dart';
import '../backend/database_operations.dart';

class HomePage extends StatefulWidget {
  HomePage() {
    if (!DatabaseOperations.initialized) {
      DatabaseOperations.init();
    }
  }
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Home'),
      // body: Column(
      //   children: [
      //     Text('Welcome!',
      //         style: TextStyle(
      //           color: Colors.green,
      //           fontSize: 30,
      //           fontWeight: FontWeight.bold,
      //         )),
      //     RaisedButton(onPressed: () async {}, child: Text('Update DB'))
      //   ],
      // ),
      body: Center(
        child: Text('Welcome!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
      ),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
