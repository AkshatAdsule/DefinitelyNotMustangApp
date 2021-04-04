import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustang_app/backend/auth_service.dart';
import 'package:mustang_app/components/logo.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    AuthService service = Provider.of<AuthService>(context);
    await service.loginWithGoogle();

    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthService>(context).currentUser;
    if (user != null) {
      Navigator.pushNamed(context, '/');
    }
    return Screen(
      left: false,
      right: false,
      top: false,
      bottom: false,
      includeHeader: false,
      includeBottomNav: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade800,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Hero(
                  tag: 'logo-splash',
                  child: Logo(
                    MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                onPressed: () => signInWithGoogle(context),
                child: Text('Sign In With Google'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: Text('Emulator Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
