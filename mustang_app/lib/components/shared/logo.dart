import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Logo extends StatelessWidget {
  double _width;

  Logo(this._width);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: _width,
        backgroundColor: Colors.white,
        child: FractionallySizedBox(
          child: Image.asset(
            'assets/logo.png',
          ),
          widthFactor: 0.8,
        ),
      ),
    );
    // return Container(
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       FractionallySizedBox(
    //         child: Container(
    //           // padding: EdgeInsets.all(10),
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: Colors.white,
    //           ),
    //         ),
    //         widthFactor: 0.4,
    //       ),
    //       FractionallySizedBox(
    //         child: Image.asset(
    //           'assets/logo.png',
    //         ),
    //         widthFactor: 0.3,
    //       ),
    //     ],
    //   ),
    // );
  }
}
