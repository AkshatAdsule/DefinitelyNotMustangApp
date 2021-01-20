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

  bool _unlocked, _animating;

  _BlurOverlayState({this.background, this.overlay, this.onEnd, this.text});
  @override
  void initState() {
    super.initState();
    _animating = false;
    _unlocked = false;
  }

  @override
  Widget build(BuildContext context) {
    return !_unlocked
        ? Stack(
            fit: StackFit.expand,
            children: <Widget>[
              IgnorePointer(child: background),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 3,
                  sigmaY: 3,
                ),
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 400),
                  opacity: _animating ? 0 : 1,
                  onEnd: () {
                    setState(() {
                      _unlocked = true;
                      onEnd();
                    });
                  },
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
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.7),
                            ],
                            stops: [
                              0.0,
                              1.0,
                            ])),
                    child: Center(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _animating = true;
                          });
                        },
                        child: text,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : background;
  }
}
