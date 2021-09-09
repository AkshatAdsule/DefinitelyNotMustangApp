import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mustang_app/components/profile/stat_display.dart';
import 'package:mustang_app/models/user_statistic.dart';

class StatRow extends StatelessWidget {
  final List<UserStatistic> stats;
  const StatRow(this.stats, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: stats
              .map((e) => StatDisplay(
                    e,
                    width: MediaQuery.of(context).size.width / 4,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
