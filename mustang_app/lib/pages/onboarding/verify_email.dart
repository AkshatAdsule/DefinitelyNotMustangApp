import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  static const String route = '/verifyemail';

  const VerifyEmail({Key key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  String _buttonText;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _buttonText = "Resend Email";
    _isLoading = false;
    AuthService service = Provider.of<AuthService>(context, listen: false);
    service.sendVerificationEmail();
  }

  Future<void> sendVerificationEmail() async {
    setState(() {
      _buttonText = "Sending Email";
      _isLoading = true;
    });
    AuthService service = Provider.of<AuthService>(context, listen: false);
    await service.sendVerificationEmail();
    setState(() {
      _buttonText = "Email Sent";
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService service = Provider.of<AuthService>(context);

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
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Verify Email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "An verification email has been sent to ${service.currentUser.email}. Follow the instructions in the email to verify your account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () => sendVerificationEmail(),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
