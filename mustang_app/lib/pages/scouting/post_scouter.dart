import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'scouter.dart';

class PostScouter extends StatelessWidget {
  static const String route = '/PostScouter';

  @override
  Widget build(BuildContext context) {
    return Screen(
        title: 'Finished!',
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(bottom: 7.5, left: 15, right: 15, top: 50),
                child: Text(
                  'Scouting Finished!',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              /*
              Container(
                padding:
                    EdgeInsets.only(top: 7.5, left: 15, right: 15, bottom: 10),
                child: Text(
                  'Where would you like to go?',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              */

              // Container(
              //   padding:
              //       EdgeInsets.only(top: 7.5, left: 15, right: 15, bottom: 10),
              //   child: RaisedButton(
              //     onPressed: () {
              //       BottomNavBar.setSelected(Calendar.route);
              //       Navigator.of(context).pushNamed(Calendar.route);
              //     },
              //     child: Text(
              //       '           Calendar           ',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     color: Colors.greenAccent,
              //     padding: EdgeInsets.all(15),
              //   ),
              // ),
              Container(
                padding:
                    EdgeInsets.only(top: 7.5, left: 15, right: 15, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Scouter.route);
                  },
                  child: Text(
                    'Scout Another Team',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
