import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/user.dart';
import 'package:mustang_app/backend/user_service.dart';
import 'package:mustang_app/exports/pages.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _initialized = false;

  void _init(BuildContext context) async {
    UserService service = Provider.of<UserService>(context);
    FirebaseUser currentUser = Provider.of<FirebaseUser>(context);
    User user = await service.getUser(currentUser?.uid);
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
