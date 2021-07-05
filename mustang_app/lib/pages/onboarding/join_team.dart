import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/onboarding/fancy_text_form_field.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/services/auth_service.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/services/user_service.dart';
import 'package:provider/provider.dart';

class JoinTeam extends StatelessWidget {
  static const String route = '/jointeam';
  final String teamNumber;
  final TeamService _teamService = new TeamService();
  JoinTeam({
    Key key,
    this.teamNumber = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider<List<Team>>.value(
        initialData: [],
        value: _teamService.streamTeams(),
        child: JoinTeamPage(
          teamNumber: teamNumber,
        ),
      ),
    );
  }
}

class JoinTeamPage extends StatefulWidget {
  final String teamNumber;
  JoinTeamPage({Key key, this.teamNumber = ""}) : super(key: key);

  @override
  _JoinTeamState createState() => _JoinTeamState(teamNumber: teamNumber);
}

class _JoinTeamState extends State<JoinTeamPage> {
  TextEditingController _team;
  String teamNumber;
  List<String> _allTeamNumbers, _tempSearchStore;
  FocusNode _focusNode;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _hasSelectedTeam;

  _JoinTeamState({this.teamNumber});

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(onFocusChanged);
    _team = new TextEditingController(text: teamNumber);
    List<Team> teams = Provider.of<List<Team>>(context, listen: false);
    List<String> teamNumbers = teams.map((e) => e.teamNumber).toList();
    _allTeamNumbers = teamNumbers;
    _tempSearchStore = teamNumbers;
    _team.addListener(onTextChanged);
    _hasSelectedTeam = false;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(onFocusChanged);
    _focusNode.dispose();
    _team.removeListener(onTextChanged);
    _team.dispose();
  }

  void onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _team.text = "";
    }
  }

  void updateTeamNumbers() {
    List<Team> teams = Provider.of<List<Team>>(context);
    if (teams != null) {
      List<String> teamNumbers = teams.map((e) => e.teamNumber).toList();
      if (!listEquals<String>(teamNumbers, _allTeamNumbers)) {
        setState(() {
          _allTeamNumbers = teamNumbers;
          _tempSearchStore = teamNumbers;
        });
      }
    }
  }

  void onTextChanged() {
    String value = _team.text;
    if (value.length == 0) {
      setState(() {
        _tempSearchStore = _allTeamNumbers;
        _hasSelectedTeam = false;
      });
      return;
    }

    bool hasSelectedTeam = false;
    List<String> temp = [];
    _allTeamNumbers.forEach((element) {
      if (element.startsWith(value)) {
        temp.add(element);
      }
      if (element == value) {
        hasSelectedTeam = true;
      }
    });
    setState(() {
      _tempSearchStore = temp;
      _hasSelectedTeam = hasSelectedTeam;
    });
  }

  showConfirmDialog(BuildContext context) {
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
                    "Join Team ${_team.text}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Team ${_team.text} will be notified of your request. Until you are accepted, you can access features as a guest.",
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
                            UserService service = new UserService(
                                Provider.of<AuthService>(context, listen: false)
                                    .currentUser
                                    .uid);
                            service.joinTeam(_team.text);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/');
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
                            "Confirm",
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

  showGuestDialog(BuildContext context) {
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
                    "Join as Guest",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "You may lose access to certain features as a guest. You can join a team anytime from the profile menu.",
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
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          onPressed: () {
                            UserService service = new UserService(
                                Provider.of<AuthService>(context, listen: false)
                                    .currentUser
                                    .uid);
                            service.browseAsGuest();
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/');
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
                            "Confirm",
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
    updateTeamNumbers();

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
                    "Join a Team",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: FancyTextFormField(
                  // focusNode: _focusNode,
                  hintText: "Team",
                  controller: _team,
                  validator: (String val) {
                    val = _team.text;
                    if (val == null || val.isEmpty) {
                      return "Please enter a team number";
                    }
                    for (String teamNumber in _allTeamNumbers) {
                      if (teamNumber == val) {
                        return null;
                      }
                    }
                    _team.text = "";
                    return "Please enter a valid team number";
                  },
                  prefixIcon: Icon(
                    _hasSelectedTeam ? Icons.check : Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height * 1.8 / 3,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _tempSearchStore.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      setState(() {
                        _team.text = _tempSearchStore[index];
                        _formKey.currentState.validate();
                        FocusScope.of(context).unfocus();
                        _hasSelectedTeam = true;
                      });
                    },
                    leading: Icon(
                      FontAwesomeIcons.users,
                      color: Colors.white,
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: _tempSearchStore[index]
                            .substring(0, _team.text.length),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _tempSearchStore[index]
                                .substring(_team.text.length),
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                      onPressed: () => showGuestDialog(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.all(10),
                        elevation: 0,
                        side: BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
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
                        if (_formKey.currentState.validate()) {
                          showConfirmDialog(context);
                        }
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
                        "Continue",
                        style: TextStyle(
                          color: Colors.green.shade700,
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
