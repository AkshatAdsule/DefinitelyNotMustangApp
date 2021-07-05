import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/pages/onboarding/join_team.dart';
import 'package:mustang_app/pages/onboarding/verify_email.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:mustang_app/components/shared/logo.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/services/dynamic_links_service.dart';
import 'package:mustang_app/services/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'home.dart';
import 'onboarding/login.dart';
import 'onboarding/register.dart';

class Splash extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _initialized = false;
  double _targetRadius = 0;
  UserModel _user;
  Timer _startAnimation;
  PendingDynamicLinkData _dynamicLinkData;

  _SplashState();

  @override
  void dispose() {
    super.dispose();
    _startAnimation.cancel();
  }

  Future<void> _init(BuildContext context) async {
    if (_startAnimation == null) {
      _startAnimation = Timer(Duration(milliseconds: 500), () {
        setState(() {
          _targetRadius = MediaQuery.of(context).size.height;
        });
      });
    }
    User currentUser = AuthService.currentUser;
    UserModel user = await AuthService.getUser(currentUser?.uid);

    await DynamicLinkService.retrieveDynamicLink(
        onLinkReceived: (PendingDynamicLinkData data) {
      print('link received: ' + data.link.path.toString());
      _dynamicLinkData = data;
    });

    setState(() {
      _user = user;
      _initialized = true;
    });
  }

  void _goToNextPage(BuildContext context) {
    User currentUser = AuthService.currentUser;
    if (_user == null && currentUser != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Register.route,
        (route) => false,
        arguments: {
          'method': SignInMethod.GOOGLE,
        },
      );
    } else if (_user == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Login.route, (route) => false);
    } else if (!currentUser.emailVerified) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(VerifyEmail.route, (route) => false);
    } else if (_user.teamStatus == TeamStatus.LONELY) {
      Navigator.pushNamed(context, JoinTeam.route);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _init(context);
    }
    return Screen(
      includeBottomNav: false,
      includeHeader: false,
      left: false,
      right: false,
      top: false,
      bottom: false,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _targetRadius),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeOut,
              builder: (BuildContext context, double radius, Widget child) {
                return CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: CirclePainter(radius, Colors.green.shade800),
                );
              },
              onEnd: () {
                if (_dynamicLinkData != null) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    _dynamicLinkData.link.path,
                    (route) => false,
                    arguments: _dynamicLinkData.link.queryParameters,
                  );
                  return;
                }
                if (_user == null) {
                  _init(context).then((value) {
                    _goToNextPage(context);
                  });
                } else {
                  _goToNextPage(context);
                }
              },
            ),
            Hero(
              tag: 'logo-splash',
              child: Logo(
                MediaQuery.of(context).size.width * 0.2,
              ),
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
  CirclePainter(this.waveRadius, Color color) {
    wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // ..strokeWidth = 2.0
  }
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    canvas.drawCircle(Offset(centerX, centerY), waveRadius, wavePaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.waveRadius != waveRadius;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
