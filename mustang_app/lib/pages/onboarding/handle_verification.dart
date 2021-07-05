import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/onboarding/fancy_text_form_field.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/pages/pages.dart';
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
  TextEditingController _password, _confirmPassword;
  bool _hidePassword, _hideConfirmPassword, _isLoading;
  String _buttonText;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _HandleVerificationState({
    Map<String, dynamic> queryParams,
  }) {
    _queryParams = queryParams;
  }

  @override
  void initState() {
    super.initState();
    _verified = false;
    _password = new TextEditingController();
    _confirmPassword = new TextEditingController();
    _hidePassword = true;
    _hideConfirmPassword = true;
    _isLoading = false;
    _buttonText = "Confirm";
    handleActionCode();
  }

  @override
  void dispose() {
    super.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _hideConfirmPassword = !_hideConfirmPassword;
    });
  }

  Future<void> handleActionCode() async {
    var actionCode = _queryParams['oobCode'];
    var mode = _queryParams['mode'];

    try {
      await AuthService.handleOobCode(actionCode);
      await AuthService.currentUser.reload();
      User currentUser = AuthService.currentUser;
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
            return;
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

  Future<void> resetPassword() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _buttonText = 'Confirming';
        _isLoading = true;
      });

      await AuthService.resetPassword(_queryParams['oobCode'], _password.text);
      setState(() {
        _buttonText = 'Confirmed!';
        _isLoading = false;
        _verified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mode = _queryParams['mode'];
    Widget body;
    if (_verified) {
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
            break;
          }

        case "resetPassword":
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
                      "Your password has been reset!",
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
                      onPressed: () =>
                          Navigator.pushNamed(context, Login.route),
                    ),
                  )
                ],
              ),
            );
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
    } else {
      switch (mode.toString()) {
        case "verifyEmail":
          {
            body = Column(
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
            body = Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Enter your new password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: FancyTextFormField(
                              obscureText: _hidePassword,
                              hintText: "Password",
                              controller: _password,
                              validator: (String val) {
                                val = _password.text;
                                if (val == null || val.isEmpty) {
                                  return "Please enter a password";
                                } else if (val.length < 6) {
                                  return "Password must be at least 6 characters";
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
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: FancyTextFormField(
                              obscureText: _hideConfirmPassword,
                              hintText: "Confirm Password",
                              controller: _confirmPassword,
                              validator: (String val) {
                                val = _confirmPassword.text;
                                if (val == null || val.length <= 0) {
                                  return "Please confirm your password";
                                } else if (val != _password.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              onSaved: (val) => print('onSave'),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hideConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    _toggleConfirmPasswordVisibility(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _buttonText,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Visibility(
                              child: CircularProgressIndicator(
                                color: Colors.green.shade700,
                                value: null,
                              ),
                              visible: _isLoading,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.all(15),
                      ),
                      onPressed: () => resetPassword(),
                    ),
                  )
                ],
              ),
            );

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
        child: body,
      ),
    );
  }
}
