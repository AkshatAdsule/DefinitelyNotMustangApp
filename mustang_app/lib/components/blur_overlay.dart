import 'dart:ui';
import 'package:flutter/material.dart';

class BlurOverlay extends StatefulWidget {
  final Widget background;
  final void Function() onEnd;
  final Text text;
  bool unlocked;
  BlurOverlay({this.background, this.onEnd, this.text, this.unlocked});

  @override
  _BlurOverlayState createState() => _BlurOverlayState(
      background: background, onEnd: onEnd, text: text, unlocked: unlocked);
}

class _BlurOverlayState extends State<BlurOverlay> {
  final Widget background, overlay;
  final void Function() onEnd;
  final Text text;
  final Duration duration = Duration(milliseconds: 200);
  final Curve curve = Curves.linear;
  bool unlocked, _animating;
  double _targetValue;

  _BlurOverlayState(
      {this.background, this.overlay, this.onEnd, this.text, this.unlocked});
  @override
  void initState() {
    super.initState();
    _targetValue = 3;
    _animating = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!unlocked) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 3, end: _targetValue),
            duration: duration,
            curve: curve,
            builder: (BuildContext context, double blur, Widget child) {
              return ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: blur,
                    sigmaY: blur,
                  ),
                  child: child);
            },
            child: IgnorePointer(child: background),
            onEnd: () {
              setState(() {
                onEnd();
              });
            },
          ),
          AnimatedContainer(
            duration: duration,
            curve: curve,
            decoration: BoxDecoration(
              gradient: _animating
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white12,
                        Colors.white12,
                      ],
                      stops: [
                        0.0,
                        1.0,
                      ],
                    ),
            ),
            child: !_animating
                ? Center(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _targetValue = 0;
                            _animating = true;
                          });
                        },
                        child: text,
                        style:
                            ElevatedButton.styleFrom(primary: Colors.red[900])),
                  )
                : Container(),
          ),
        ],
      );
    } else {
      return background;
    }
  }
}
