import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class HandleVerification extends StatefulWidget {
  static const String route = '/handleverification';
  Map<String, dynamic> _queryParams;

  HandleVerification({Key key, Map<String, dynamic> queryParams})
      : super(key: key) {
    _queryParams = queryParams;
  }

  @override
  _HandleVerificationState createState() =>
      _HandleVerificationState(queryParams: _queryParams);
}

class _HandleVerificationState extends State<HandleVerification> {
  Map<String, dynamic> _queryParams;
  bool _verified;

  _HandleVerificationState({Map<String, dynamic> queryParams}) {
    _queryParams = queryParams;
  }

  @override
  void initState() {
    super.initState();
    _verified = false;
    handleActionCode();
  }

  Future<void> handleActionCode() async {
    AuthService _authService = Provider.of<AuthService>(context, listen: false);

    var actionCode = _queryParams['oobCode'];
    var mode = _queryParams['mode'];

    try {
      await _authService.handleOobCode(actionCode);
      await _authService.currentUser.reload();
      User currentUser = _authService.currentUser;
      switch (mode.toString()) {
        case "verifyEmail":
          {
            if (!currentUser.emailVerified) {
              return;
            }
            break;
          }

        case "recoverEmail":
          {
            break;
          }

        case "resetPassword":
          {
            break;
          }
        default:
          {
            break;
          }
      }
      setState(() {
        _verified = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mode = _queryParams['mode'];
    Widget body;
    switch (mode.toString()) {
      case "verifyEmail":
        {
          body = Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 200,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Your email has been verified!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: Text(
                      "Continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(15),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/'),
                  ),
                )
              ],
            ),
          );
          break;
        }

      case "recoverEmail":
        {
          body = Container();
          break;
        }

      case "resetPassword":
        {
          body = Container();
          break;
        }
      default:
        {
          body = Center(
            child: Text(
              "An error occured",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
    }

    return Screen(
      left: false,
      right: false,
      top: false,
      bottom: false,
      includeHeader: false,
      includeBottomNav: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: !_verified
            ? body
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: CircularProgressIndicator(
                      value: null,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Verifying...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
