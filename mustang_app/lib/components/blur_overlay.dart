import 'dart:ui';
import 'package:flutter/material.dart';

class BlurOverlay extends StatelessWidget {
  Widget background, overlay;

  BlurOverlay({this.background, this.overlay});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        IgnorePointer(child: background),
        Center(
          // <-- clips to the 200x200 [Container] below
          child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3.0,
                sigmaY: 3.0,
              ),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.grey.shade300.withOpacity(0.4)),
                child: Center(
                  child: overlay,
                ),
              )),
        ),
      ],
    );
  }
}
