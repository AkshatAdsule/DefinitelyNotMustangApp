import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/onboarding/fancy_text_form_field.dart';
import 'package:mustang_app/components/onboarding/social_button.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/pages/onboarding/handle_verification.dart';
import 'package:mustang_app/pages/onboarding/register.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:mustang_app/components/shared/logo.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/services/dynamic_links_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Login extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword;
  TextEditingController _email, _password;

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
    _email = new TextEditingController();
    _password = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    DynamicLinkService service = new DynamicLinkService();
    Uri uri = await service.getLinkFromFirebase('/register');
    Share.share(uri.toString());
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    AuthService service = Provider.of<AuthService>(context, listen: false);
    try {
      UserCredential cred = await service.loginWithGoogle();
      UserModel model = await service.getUser(cred.user.uid);
      if (model == null) {
        Navigator.pushNamed(
          context,
          Register.route,
          arguments: {
            'method': SignInMethod.GOOGLE,
          },
        );
      } else if (!service.currentUser.emailVerified) {
        Navigator.pushNamed(context, HandleVerification.route);
      } else {
        Navigator.pushNamed(context, '/');
      }
    } on FirebaseException catch (error) {
      String message = "An error occurred. Try again later";
      switch (error.code) {
        case "account-exists-with-different-credential":
          {
            break;
          }
        case "user-not-found":
          {
            showRegisterDialog(context);
            return;
          }
        case "user-disabled":
          {
            message = "Your account has been disabled";
            break;
          }
        case "wrong-password":
          {
            message = "Incorrect password";
            break;
          }
        default:
          {
            break;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error ocurred, try again later."),
        ),
      );
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    AuthService service = Provider.of<AuthService>(context, listen: false);
    try {
      UserCredential cred =
          await service.loginWithEmailAndPassword(_email.text, _password.text);
      UserModel model = await service.getUser(cred.user.uid);
      if (model == null) {
        Navigator.pushNamed(
          context,
          Register.route,
          arguments: {
            'method': SignInMethod.EMAIL_PASSWORD,
          },
        );
      } else {
        Navigator.pushNamed(context, '/');
      }
    } on FirebaseException catch (error) {
      String message = "An error occurred. Try again later";
      switch (error.code) {
        case "invalid-email":
          {
            message = "Please enter a valid email address";
            break;
          }
        case "user-not-found":
          {
            showRegisterDialog(context);
            return;
          }
        case "user-disabled":
          {
            message = "Your account has been disabled";
            break;
          }
        case "wrong-password":
          {
            message = "Incorrect password";
            break;
          }
        default:
          {
            break;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(message),
            ),
          );
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error ocurred, try again later."),
        ),
      );
    }
  }

  showRegisterDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "An account with this email has not been created yet. Would you like to sign up?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.all(10),
                            elevation: 5,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              Register.route,
                              arguments: {
                                'method': SignInMethod.EMAIL_PASSWORD,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.all(10),
                            elevation: 5,
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade400,
              Colors.green.shade800,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: FancyTextFormField(
                        hintText: "Email",
                        controller: _email,
                        validator: (String val) {
                          if (val == null || val.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: FancyTextFormField(
                        obscureText: _hidePassword,
                        hintText: "Password",
                        controller: _password,
                        validator: (String val) {
                          if (val == null || val.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () => _togglePasswordVisibility(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: input validation and error handling
                  if (_formKey.currentState.validate()) {
                    signInWithEmailAndPassword(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(15),
                  elevation: 5,
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "-  OR  -",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Sign in with",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                      onPressed: () => signInWithFacebook(context),
                      icon: Image.asset('assets/facebook.jpg')),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  SocialButton(
                      onPressed: () => signInWithGoogle(context),
                      icon: Image.asset('assets/google.jpg')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Register.route,
                        arguments: {
                          'method': SignInMethod.EMAIL_PASSWORD,
                        },
                      ),
                      child: Text(
                        "Sign Up!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
