import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchDisplay extends StatefulWidget {
  @override
  _StopwatchDisplayState createState() => _StopwatchDisplayState();
}

class _StopwatchDisplayState extends State<StopwatchDisplay> {
  Stopwatch _stopwatch;
  Timer _refreshTimer;

  _StopwatchDisplayState() {
    _stopwatch = new Stopwatch();
    _stopwatch.start();
    _refreshTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_refreshTimer != null) {
      _refreshTimer.cancel();
    }
    if (_stopwatch != null) {
      _stopwatch.stop();
    }
  }

  String _formatTime(int milliseconds) {
    int secs = milliseconds ~/ 1000;
    String minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    String seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_stopwatch.elapsedMilliseconds),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
