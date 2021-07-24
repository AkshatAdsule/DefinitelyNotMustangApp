import 'package:flutter/material.dart';
import 'package:mustang_app/components/profile/badge.dart';
import 'package:mustang_app/components/profile/stat_row.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/pages/onboarding/join_team.dart';
import 'package:mustang_app/pages/pages.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const String route = '/profile';
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logout() async {
    await AuthService.logout();
    Navigator.of(context).pushNamed(Login.route);
  }

  void changeTeam() {
    Navigator.of(context).pushNamed(JoinTeam.route);
  }

  Future<void> changeEmail() async {
    // TODO change email
  }

  void editProfile() {
    // TODO edit profile
  }

  Future<void> deleteAccount() async {
    await AuthService.deleteAccount();
    Navigator.of(context).pushNamed(Login.route);
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context) ??
        UserModel(
          firstName: "Horse",
          lastName: "Head",
          email: "horseybusiness@gmail.com",
          uid: "",
          userType: UserType.MEMBER,
          teamNumber: "670",
          teamStatus: TeamStatus.JOINED,
        );
    return Screen(
      title: "Profile",
      top: false,
      bottom: false,
      left: false,
      right: false,
      includeHeader: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(),
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
          children: [
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Image.network(
                            AuthService.currentUser?.photoURL ??
                                'https://firebasestorage.googleapis.com/v0/b/mustangapp-b1398.appspot.com/o/logo.png?alt=media&token=f45e368d-3cba-4d67-b8d5-2e554f87e046',
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "${user.firstName} ${user.lastName}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "Team 670",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "MEMBER",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Badge(),
                            Badge(),
                            Badge(),
                            Badge(),
                            Badge(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextButton(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => editProfile(),
                          style: TextButton.styleFrom(
                            primary: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 7,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: StatRow(
                        user.stats,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: FancyButton(
                          width: MediaQuery.of(context).size.width * 0.7,
                          text: "Change Email",
                          onPressed: () => changeEmail()),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: FancyButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        text: "Change Team",
                        onPressed: () => changeTeam(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: FancyButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        text: "Log Out",
                        onPressed: () => logout(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: FancyButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        text: "Delete Account",
                        onPressed: () => deleteAccount(),
                        buttonColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FancyButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double width;
  final Color buttonColor, textColor;

  const FancyButton({
    Key key,
    this.onPressed,
    this.text = "",
    this.width = 100,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: buttonColor ?? Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(15),
          elevation: 5,
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: textColor ?? Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
