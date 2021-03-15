import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import '../components/header.dart';
import '../components/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "You Are Welcome 💚",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Text(
                      "Created by:",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    ...Constants.creators
                        .map(
                          (e) => Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              e.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
