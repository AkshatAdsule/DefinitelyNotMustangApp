import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurOverlay extends StatefulWidget {
  final Widget background;
  final void Function() onEnd;
  final Text text;
  BlurOverlay({this.background, this.onEnd, this.text});

  @override
  _BlurOverlayState createState() =>
      _BlurOverlayState(background: background, onEnd: onEnd, text: text);
}

class _BlurOverlayState extends State<BlurOverlay> {
  final Widget background, overlay;
  final void Function() onEnd;
  final Text text;
  final Duration duration = Duration(milliseconds: 500);
  final Curve curve = Curves.ease;
  bool _unlocked, _animating;
  double _targetValue;

  _BlurOverlayState({this.background, this.overlay, this.onEnd, this.text});
  @override
  void initState() {
    super.initState();
    _targetValue = 3;
    _unlocked = false;
    _animating = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
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
                _unlocked = true;
                onEnd();
              });
            },
          ),

          AnimatedOpacity(
            opacity: _animating ? 0 : 1,
            duration: duration,
            curve: curve,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: Offset(2, 2))
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.5),
                      ],
                      stops: [
                        0.0,
                        1.0,
                      ])),
              child: !_animating
                  ? Center(
                      child: RaisedButton(
                        color: Colors.red.shade900,
                        onPressed: () {
                          setState(() {
                            _targetValue = 0;
                            _animating = true;
                          });
                        },
                        child: text,
                      ),
                    )
                  : Container(),
            ),
          )
          // )
        ],
      );
    } else {
      return background;
    }
  }
}
