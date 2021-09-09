import 'package:flutter/material.dart';
import 'package:mustang_app/models/user_statistic.dart';

class StatDisplay extends StatelessWidget {
  final UserStatistic stat;
  final double width;
  const StatDisplay(
    this.stat, {
    Key key,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              stat.total.toInt().toString(),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: width * 0.7,
            margin: EdgeInsets.only(top: 10),
            child: Text(
              stat.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
