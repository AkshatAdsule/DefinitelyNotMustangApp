import 'package:flutter/material.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/constants/constants.dart';

class Glossary extends StatefulWidget {
  static const String route = '/';
  @override
  State<StatefulWidget> createState() {
    return GlossaryState();
  }
}

class GlossaryState extends State<Glossary> {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Glossary',
      left: false,
      right: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // child: Text(
              //   "U R Welcome 💚",
              //   style: TextStyle(
              //     color: Colors.green,
              //     fontSize: 30,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    // Text(
                    //   "Created by:",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 18,
                    //   ),
                    // ),
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
    );
  }
}
