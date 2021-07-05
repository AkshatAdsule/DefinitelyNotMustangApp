import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/onboarding/fancy_text_form_field.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/pages/onboarding/verify_email.dart';
import 'package:mustang_app/pages/pages.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  static const String route = '/register';
  SignInMethod _method;

  Register({
    Key key,
    SignInMethod method = SignInMethod.EMAIL_PASSWORD,
  }) : super(key: key) {
    _method = method;
  }

  @override
  _RegisterState createState() => _RegisterState(method: _method);
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email,
      _password,
      _confirmPassword,
      _firstName,
      _lastName;

  bool _hidePassword, _hideConfirmPassword;
  SignInMethod _method;

  _RegisterState({@required SignInMethod method}) {
    _method = method;
  }

  @override
  void initState() {
    super.initState();
    _email = new TextEditingController();
    _password = new TextEditingController();
    _confirmPassword = new TextEditingController();
    _firstName = new TextEditingController();
    _lastName = new TextEditingController();
    _hidePassword = true;
    _hideConfirmPassword = true;
  }

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
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

  Future<void> createAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      String email = _method != SignInMethod.EMAIL_PASSWORD
          ? AuthService.currentUser.email
          : _email.text;
      await AuthService.createAccount(
          _firstName.text, _lastName.text, email, _password.text, _method);
      print('here');
      Navigator.pushNamed(context, VerifyEmail.route);
    } on FirebaseAuthException catch (error) {
      print('firebase error: ${error.message}');
      String message = "An error occurred. Try again later";
      switch (error.code) {
        case "invalid-email":
          {
            message = "Please enter a valid email address";
            break;
          }
        case "email-already-in-use":
          {
            message = "An account with this email has already been created";
            break;
          }
        case "weak-password":
          {
            message = "Password must be";
            break;
          }
        default:
          {
            break;
          }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ),
      );
    } catch (error) {
      print('error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error ocurred, try again later."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
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
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: FancyTextFormField(
                          hintText: "First Name",
                          controller: _firstName,
                          validator: (String val) {
                            val = _firstName.text;
                            if (val == null || val.isEmpty) {
                              return "Please enter your first name";
                            }

                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: FancyTextFormField(
                          hintText: "Last Name",
                          controller: _lastName,
                          validator: (String val) {
                            val = _lastName.text;

                            if (val == null || val.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ...(_method == SignInMethod.EMAIL_PASSWORD
                          ? [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: FancyTextFormField(
                                  hintText: "Email",
                                  controller: _email,
                                  validator: (String val) {
                                    val = _email.text;

                                    if (val == null || val.isEmpty) {
                                      return "Please enter your email";
                                    } else if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)) {
                                      return "Please enter a valid email address";
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
                                    onPressed: () =>
                                        _togglePasswordVisibility(),
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
                            ]
                          : [
                              SizedBox.shrink(),
                            ]),
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
                      createAccount(context);
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
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
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
                        onTap: () => Navigator.pushNamed(context, Login.route),
                        child: Text(
                          "Log In!",
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
      ),
    );
  }
}
