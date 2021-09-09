import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/onboarding/fancy_text_form_field.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/services/user_service.dart';

class CreateTeam extends StatefulWidget {
  static const String route = '/createteam';

  const CreateTeam({Key key}) : super(key: key);

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _teamNumber, _teamName, _region, _teamEmail;
  bool _created;

  @override
  void initState() {
    super.initState();
    _created = false;
    _teamNumber = new TextEditingController();
    _teamName = new TextEditingController();
    _region = new TextEditingController();
    _teamEmail = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _teamNumber.dispose();
    _teamName.dispose();
    _teamEmail.dispose();
    _region.dispose();
  }

  Future<void> createTeam() async {
    try {
      TeamService teamService = new TeamService(_teamNumber.text);
      UserService service = new UserService(AuthService.currentUser.uid);
      UserModel currentUser =
          await AuthService.getUser(AuthService.currentUser.uid);

      await TeamService.createTeam(
        Team(
          teamNumber: _teamNumber.text,
          teamName: _teamName.text,
          teamEmail: _teamEmail.text,
          region: _region.text,
          bottomPort: false,
          innerPort: false,
          outerPort: false,
          rotationControl: false,
          positionControl: false,
          hasClimber: false,
          hasLeveller: false,
          drivebaseType: DriveBaseType.TANK,
        ),
      );
      await teamService.addMember(currentUser);
      await service.promoteUser(type: UserType.OFFICER);
      setState(() {
        _created = true;
      });
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
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
            children: _created
                ? [
                    Container(
                      width: double.infinity,
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
                              "Your team has been created!",
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
                                  Navigator.pushNamed(context, '/'),
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                : [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create Team",
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
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: FancyTextFormField(
                                hintText: "Team Name",
                                controller: _teamName,
                                validator: (String val) {
                                  val = _teamName.text;
                                  if (val == null || val.isEmpty) {
                                    return "Please enter your team name";
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
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: FancyTextFormField(
                                hintText: "Team Number",
                                controller: _teamNumber,
                                validator: (String val) {
                                  val = _teamNumber.text;

                                  if (val == null || val.isEmpty) {
                                    return "Please enter your team number";
                                  }
                                  return null;
                                },
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: FancyTextFormField(
                                hintText: "Team Email",
                                controller: _teamEmail,
                                validator: (String val) {
                                  val = _teamEmail.text;

                                  if (val == null || val.isEmpty) {
                                    return "Please enter your team's email";
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
                                hintText: "Region",
                                controller: _region,
                                validator: (String val) {
                                  val = _region.text;
                                  if (val == null || val.isEmpty) {
                                    return "Please enter your region";
                                  }
                                  return null;
                                },
                                prefixIcon: Icon(
                                  FontAwesomeIcons.globeAmericas,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    createTeam();
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
                                  "CREATE TEAM",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
