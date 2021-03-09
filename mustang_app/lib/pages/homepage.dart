import 'package:flutter/material.dart';
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
      body: Column(children: [
        Text("UR Welcome <3",
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        Text(
            "Made by: Akshat Adsule, Antonio Cuan, Arnav Kulkarni, Elise Vambenepe, Laksh Bhambhani, Katia Bravo and Tarini Maram",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            )),
      ]),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
