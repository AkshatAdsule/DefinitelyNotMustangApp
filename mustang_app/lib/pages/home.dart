import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/constants/legacy.dart';
import 'package:mustang_app/pages/pages.dart';
import 'package:mustang_app/pages/pre_event_analysis/input_screen.dart';
import 'package:mustang_app/pages/sketcher.dart';

class Home extends StatefulWidget {
  static const String route = '/';
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  Widget _buildLinkButton({String route, String label}) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(label));
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Home',
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            Text(
              'Check out all the parts of The Mustang Alliance!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildLinkButton(
                route: InputScreen.route, label: 'Pre Event Analysis'),
            _buildLinkButton(route: Scouter.route, label: 'Scouter'),
            _buildLinkButton(route: SearchPage.route, label: 'Team Data'),
            _buildLinkButton(route: SketchPage.route, label: 'Match Planner'),
          ],
        ),
      ),
      // child: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 20),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //         child: Text(
      //           "U R Welcome 💚",
      //           style: TextStyle(
      //             color: Colors.green,
      //             fontSize: 30,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       Center(
      //         child: Container(
      //           margin: EdgeInsets.only(top: 5),
      //           child: Column(
      //             children: [
      //               Text(
      //                 "Created by:",
      //                 style: TextStyle(
      //                   color: Colors.grey,
      //                   fontSize: 18,
      //                 ),
      //               ),
      //               ...Legacy.creators
      //                   .map(
      //                     (e) => Container(
      //                       margin: EdgeInsets.only(top: 5),
      //                       child: Text(
      //                         e.toString(),
      //                         style: TextStyle(
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.green,
      //                         ),
      //                       ),
      //                     ),
      //                   )
      //                   .toList(),
      //               SizedBox(
      //                 height: 100,
      //               ),
      //               Container(
      //                 child: Column(
      //                   children: [
      //                     Text(
      //                       "Pre-Event data version: ${Constants.DATA_ANALYSIS_DATA_VERSION}",
      //                     ),
      //                     Text(
      //                       "Data-Collection data version: ${Constants.DATA_COLLECTION_DATA_VERSION}",
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
