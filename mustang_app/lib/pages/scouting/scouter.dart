import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'pit_scouting.dart';
import '../../components/header.dart';
import 'auton_scouting.dart';
import '../../components/bottom_nav_bar.dart';
import '../../backend/scouting_operations.dart';
import 'package:flutter/material.dart';
class Scouter extends StatefulWidget {
  static const String route = '/Scouter';

  @override
  State<StatefulWidget> createState() {
    return new _ScouterState();
  }
}

class _ScouterState extends State<Scouter> {
  TextEditingController _teamNumberController = TextEditingController();
  TextEditingController _matchNumberController = TextEditingController();
  TextEditingController _namesController = new TextEditingController();
  String _allianceColor = "Blue Alliance";
  int _allianceNum = 0;

  bool _showError = false;
  ScoutingOperations db = new ScoutingOperations();
  /*
   _handleRadioValueChange (String color){
    setState(() {
      _allianceColor = color;
      switch(color){
        case "Blue Alliance" : { debugPrint("blue");}
        break;

        case "Red Alliance" : { debugPrint("red");}
        break;

        default: {debugPrint("default");}
        break;
      }
    });
  }
  */
  
  showAlertDialog(BuildContext context, bool pit) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Override"),
      onPressed: () {
        Navigator.pop(context);
        if (pit) {
          db.startPitScouting(
              _teamNumberController.text, _namesController.text);
          Navigator.pushNamed(context, PitScouter.route, arguments: {
            'teamNumber': _teamNumberController.text,
          });
        } else {
          db.startNewMatch(_teamNumberController.text,
              _matchNumberController.text, _namesController.text);
          Navigator.pushNamed(context, AutonScouter.route, arguments: {
            'teamNumber': _teamNumberController.text,
            'matchNumber': _matchNumberController.text
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Overwrite Data"),
      content: Text(pit
          ? "Pit data for this team already.\nAre you sure you want to overwrite it?"
          : "Match data for this team and match number already.\nAre you sure you want to overwrite it?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String _allianceColor;
        return Scaffold(
          appBar: Header(
            context,
            'Pre Game Notes',
          ),
          body: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 15),
                child: TextField(
                  controller: _teamNumberController,
                  decoration: InputDecoration(
                    labelText: 'Team Number',
                    errorText: _showError ? 'Team number is required' : null,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: TextField(
                  controller: _matchNumberController,
                  decoration: InputDecoration(
                    labelText: 'Match Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: TextField(
                  controller: _namesController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          new Radio(
                            value: 0,
                            groupValue: _allianceNum,
                            onChanged: (int value) {
                              setState((){
                                _allianceNum = value;
                                Constants.fieldColor = value;

                              });
                            }
                          ),
                          new Text(
                            'Blue Alliance',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                            value: 1,
                            groupValue: _allianceNum,
                            onChanged: (int value) {
                              setState((){
                                _allianceNum = value;
                                Constants.fieldColor = value;
                                debugPrint(Constants.fieldColor.toString());

                              });
                            }
                          ),
                          new Text(
                            'Red Alliance',
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),                  
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            child: new Builder(
              builder: (BuildContext buildContext) => RaisedButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    if (_teamNumberController.text.isEmpty) {
                      Scaffold.of(buildContext).showSnackBar(SnackBar(
                        content: Text("Enter a team number"),
                      ));
                      return;
                    } else if (_namesController.text.isEmpty) {
                      Scaffold.of(buildContext).showSnackBar(SnackBar(
                        content: Text("Enter a name"),
                      ));
                      return;
                    }
                    db
                        .doesPitDataExist(_teamNumberController.text)
                        .then((onValue) {
                      if (onValue) {
                        showAlertDialog(context, true);
                      } else {
                        db.startPitScouting(
                            _teamNumberController.text, _namesController.text);
                        Navigator.pushNamed(context, PitScouter.route,
                            arguments: {
                              'teamNumber': _teamNumberController.text,
                            });
                      }
                    });
                  });
                },
                padding: EdgeInsets.all(15),
                child: Text(
                  'Pit Scouting',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            child: new Builder(
              builder: (BuildContext buildContext) => new RaisedButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, MapScouting.route, arguments: {
                    'teamNumber': _teamNumberController.text,
                    'matchNumber': _matchNumberController.text
                  });
                  return;
                  setState(() {
                    if (_teamNumberController.text.isEmpty) {
                      Scaffold.of(buildContext).showSnackBar(SnackBar(
                        content: Text("Enter a team number"),
                      ));
                      return;
                    } else if (_matchNumberController.text.isEmpty) {
                      Scaffold.of(buildContext).showSnackBar(SnackBar(
                        content: Text("Enter a match number"),
                      ));
                      return;
                    } else if (_namesController.text.isEmpty) {
                      Scaffold.of(buildContext).showSnackBar(SnackBar(
                        content: Text("Enter a name"),
                      ));
                      return;
                    }
                    db
                        .doesMatchDataExist(_teamNumberController.text,
                            _matchNumberController.text)
                        .then((onValue) {
                      if (onValue) {
                        showAlertDialog(context, false);
                      } else {
                        db.startNewMatch(_teamNumberController.text,
                            _matchNumberController.text, _namesController.text);
                        Navigator.pushNamed(context, AutonScouter.route,
                            arguments: {
                              'teamNumber': _teamNumberController.text,
                              'matchNumber': _matchNumberController.text
                            });
                      }
                    });
                  });
                },
                padding: EdgeInsets.all(15),
                child: Text(
                  'Match Scouting',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: BottomNavBar(context),
    )]));
  }
}
