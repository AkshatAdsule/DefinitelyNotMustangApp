import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/user.dart';
import 'package:mustang_app/backend/user_service.dart';
import 'package:mustang_app/exports/pages.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Splash extends StatefulWidget {
  static const String route = '/splash';
  bool _useFirebase = true;

  Splash({bool useFirebase = true}) {
    _useFirebase = useFirebase;
  }

  @override
  _SplashState createState() => _SplashState(_useFirebase);
}

class _SplashState extends State<Splash> {
  bool _initialized = false, _useFirebase;
  double _targetRadius = 0;

  _SplashState(this._useFirebase);

  void _init(BuildContext context) async {
    setState(() {
      _targetRadius = 10;
    });
    if (!_useFirebase) {
      return;
    }
    UserService service = Provider.of<UserService>(context);
    User currentUser = Provider.of<User>(context);
    UserModel user = await service.getUser(currentUser?.uid);
    setState(() {
      _initialized = true;
    });
    if (user == null) {
      Navigator.of(context).pushNamed(Login.route);
    } else {
      Navigator.of(context).pushNamed(HomePage.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _init(context);
    }
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // TweenAnimationBuilder(
            //   tween: Tween<double>(begin: 0, end: _targetRadius),
            //   duration: Duration(seconds: 2),
            //   curve: Curves.easeOut,
            //   builder: (BuildContext context, double radius, Widget child) {
            //     return CustomPaint(
            //       size: Size(double.infinity, double.infinity),
            //       painter: CirclePainter(radius),
            //     );
            //   },
            //   onEnd: () {},
            // ),
            FractionallySizedBox(
              child: Builder(
                builder: (BuildContext context) {
                  return CircleAvatar(
                    radius: MediaQuery.of(context).size.width,
                    backgroundColor: Theme.of(context).canvasColor,
                    child: Image.asset('assets/logo.png'),
                  );
                },
              ),
              widthFactor: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double waveRadius;
  var wavePaint;
  CirclePainter(this.waveRadius) {
    wavePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      // ..strokeWidth = 2.0
      ..isAntiAlias = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double maxRadius = hypot(centerX, centerY);

    var currentRadius = waveRadius;
    // while (currentRadius < maxRadius) {
    if (currentRadius < maxRadius)
      canvas.drawCircle(Offset(centerX, centerY), currentRadius, wavePaint);
    //   currentRadius += 10.0;
    // }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.waveRadius != waveRadius;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
