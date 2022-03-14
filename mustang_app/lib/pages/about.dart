import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/constants/legacy.dart';

class About extends StatefulWidget {
  static const String route = '/';
  @override
  State<StatefulWidget> createState() {
    return AboutState();
  }
}

class AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Home',
      left: false,
      right: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "U R Welcome 💚",
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
                    ...Legacy.creators
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
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Pre-Event data version: ${Constants.DATA_ANALYSIS_DATA_VERSION}",
                          ),
                          Text(
                            "Data-Collection data version: ${Constants.DATA_COLLECTION_DATA_VERSION}",
                          ),
                        ],
                      ),
                    ),
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
