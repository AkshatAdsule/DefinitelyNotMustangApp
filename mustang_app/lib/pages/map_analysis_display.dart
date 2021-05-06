import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/game_replay_key.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/map_analysis_key.dart';
import 'package:mustang_app/components/mode_toggle.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/components/select.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:provider/provider.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class MapAnalysisDisplay extends StatelessWidget {
  TeamService _teamService = TeamService();
  static const String route = '/MapAnalysisDisplay';
  //remove team num
  String _teamNumber = '';
  MapAnalysisDisplay({String teamNumber}) {
    _teamNumber = teamNumber;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Team>.value(
      initialData: null,
      value: _teamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: _teamService.streamMatches(_teamNumber),
        initialData: [],
        child: MapAnalysisDisplayPage(
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MapAnalysisDisplayPage extends StatefulWidget {
  //remove team num
  String _teamNumber = '';
  MapAnalysisDisplayPage({String teamNumber}) {
    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return new _MapAnalysisDisplayState(_teamNumber);
  }
}

class _MapAnalysisDisplayState extends State<MapAnalysisDisplayPage> {
  Analyzer myAnalyzer;
  List<List<Object>> actionRelatedColors = [
    ["OTHER", Colors.orange],
    ["FOUL", Colors.yellow],
    ["PUSH", Colors.deepPurple],
    ["PREV", Colors.pink[200]],
    ["MISSED", Colors.red],
    ["INTAKE", Colors.blue],
    ["SHOT", Colors.green],
    ["LOW", Colors.white],
    ["OUTER", Colors.grey],
    ["INNER", Colors.black],
  ];
  List<bool> _toggleModes = [
    true,
    false,
    false,
  ];
  double timeInGame = 10;
  GameMap gameMap;
  String selectedMatch = "ALL";
  ActionType selectedActionType = ActionType.ALL;

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer();
  }

  @override
  void initState() {
    super.initState();
  }

  int _getScoringColorValue(ActionType actionType, int x, int y) {
    double totalNumGames = myAnalyzer.totalNumGames().toDouble();
    double ptsAtZone =
        myAnalyzer.calcPtsAtZone(actionType, x.toDouble(), y.toDouble()) /
            totalNumGames;

    double ptsAtZonePerGame = ptsAtZone / totalNumGames;
    double colorValue =
        ((ptsAtZonePerGame / Constants.maxPtValuePerZonePerGame) * 900);
    int lowerBound = 0, upperBound = 0;
    if (!colorValue.isNaN && colorValue.isFinite) {
      lowerBound = (colorValue ~/ 100) * 100; //lower bound of 100
      upperBound = (colorValue ~/ 100 + 1) * 100; //upper bound
    }

    int returnVal = (colorValue - lowerBound > upperBound - colorValue)
        ? upperBound
        : lowerBound;
    if (returnVal > 900) {
      return 900;
    }
    return returnVal;
  }

  int _getAccuracyColorValue(ActionType actionType, int x, int y) {
    double zoneAccuracyOutOf1 = myAnalyzer.calcShotAccuracyAtZone(
        actionType, x.toDouble(), y.toDouble());

    double zoneAccuracyOutOf900 = zoneAccuracyOutOf1 * 900;
    if (!zoneAccuracyOutOf900.isInfinite && !zoneAccuracyOutOf900.isNaN) {
      int a = (zoneAccuracyOutOf900 ~/ 100) * 100; //lower bound of 100
      int b = (zoneAccuracyOutOf900 ~/ 100 + 1) * 100; //upper bound
      int returnVal =
          (zoneAccuracyOutOf900 - a > b - zoneAccuracyOutOf900) ? b : a;
      return returnVal;
    } else {
      return 0;
    }
  }

  List<GameAction> getAllMatchActions(BuildContext context) {
    if (selectedMatch == "ALL") {
      return Provider.of<List<Match>>(context)
          .map((e) => e.actions)
          .reduce((value, element) => [...value, ...element]);
    }
    return Provider.of<List<Match>>(context)
        .where((element) => element.matchNumber == selectedMatch)
        .map((e) => e.actions)
        .reduce((value, element) => [...value, ...element]);
  }

  List<Color> _getColorCombo(BuildContext context, int x, int y) {
    GameAction curr;
    List<GameAction> currActions = getAllMatchActions(context)
        .where((element) => element.timeStamp > timeInGame * 1000 - 5000)
        .where((element) => element.timeStamp < timeInGame * 1000 + 1000)
        .toList();
    for (GameAction currentAction in currActions) {
      if (currentAction.x == x && currentAction.y == y) {
        curr = currentAction;
        break;
      }
    }
    if (curr == null) return [Colors.green[0], Colors.transparent];

    List<Color> gradientCombo = [];
    String actionType = curr.action.toString();

    for (List<Object> shade in actionRelatedColors)
      if (actionType.contains(shade[0])) gradientCombo.add(shade[1]);

    if (gradientCombo.length < 2) {
      if (actionType.contains("FOUL")) {
        gradientCombo.add(Colors.yellow[600]);
      } else if (actionType.contains("OTHER")) {
        gradientCombo.add(Colors.orange[600]);
      }
    }

    return gradientCombo;
  }

  Widget _getCell(BuildContext context, int x, int y, bool isSelected,
      double cellWidth, double cellHeight) {
    int ind = _toggleModes.indexOf(true);
    switch (ind) {
      case 0:
        {
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
              color: (Colors.green[
                          _getScoringColorValue(selectedActionType, x, y)] ==
                      null)
                  ? null
                  : Colors
                      .green[_getScoringColorValue(selectedActionType, x, y)]
                      .withOpacity(0.7),
            ),
          );
        }
      case 1:
        {
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
                color: (Colors.green[
                            _getAccuracyColorValue(selectedActionType, x, y)] ==
                        null)
                    ? null
                    : Colors
                        .green[_getAccuracyColorValue(selectedActionType, x, y)]
                        .withOpacity(0.7)),
          );
        }
      case 2:
        {
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: (x != 0 && y != 0)
                ? BoxDecoration(
                    color: _getColorCombo(context, x, y).first,
                    // gradient: RadialGradient(
                    //   colors: _getColorCombo(context, x, y),
                    // ),
                  )
                : BoxDecoration(color: Colors.transparent),
          );
        }
      default:
        {
          return Container();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      myAnalyzer.init(
        Provider.of<Team>(context),
        Provider.of<List<Match>>(context),
      );
      setState(() {});
    }

    return Screen(
      title: 'Map Analysis for Team: ' + myAnalyzer.teamNum.toString(),
      includeBottomNav: false,
      child: Container(
        child: GameMap(
          zoneGrid: ZoneGrid(
            GlobalKey(),
            (int x, int y) {},
            (
              int x,
              int y,
              bool isSelected,
              double cellWidth,
              double cellHeight,
            ) =>
                _getCell(
              context,
              x,
              y,
              isSelected,
              cellWidth,
              cellHeight,
            ),
          ),
          sideWidget: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ModeToggle(
                    onPressed: (int ind) {
                      setState(
                        () {
                          List<bool> newToggle = List.generate(
                              _toggleModes.length, (index) => index == ind);
                          _toggleModes = newToggle;
                        },
                      );
                    },
                    isSelected: _toggleModes,
                    direction: Axis.horizontal,
                    children: [
                      ModeToggleChild(
                        icon: Icons.gps_fixed,
                        isSelected: _toggleModes[0],
                      ),
                      ModeToggleChild(
                        icon: FontAwesomeIcons.bullseye,
                        isSelected: _toggleModes[1],
                      ),
                      ModeToggleChild(
                        icon: FontAwesomeIcons.history,
                        isSelected: _toggleModes[2],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Select<ActionType>(
                      value: selectedActionType,
                      onChanged: (val) => setState(() {
                        selectedActionType = val;
                      }),
                      items: [
                        ActionType.ALL,
                        ActionType.SHOT_LOW,
                        ActionType.SHOT_OUTER,
                        ActionType.SHOT_INNER
                      ].map<DropdownMenuItem<ActionType>>(
                        (ActionType actionType) {
                          return DropdownMenuItem<ActionType>(
                            value: actionType,
                            child: Center(
                              child: Text(
                                actionType.toString().substring(
                                      actionType.toString().indexOf('.') + 1,
                                    ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    Select<String>(
                      value: selectedMatch,
                      onChanged: (val) => setState(() {
                        selectedMatch = val;
                      }),
                      items: [
                        ...Provider.of<List<Match>>(context)
                            .map<DropdownMenuItem<String>>(
                          (Match match) {
                            return DropdownMenuItem<String>(
                              value: match.matchNumber,
                              child: Center(
                                child: Text(
                                  match.matchNumber,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        DropdownMenuItem<String>(
                          value: "ALL",
                          child: Center(
                            child: Text(
                              "ALL",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: IndexedStack(
                      index: _toggleModes.indexOf(true),
                      children: [
                        MapAnalysisKey(true),
                        MapAnalysisKey(false),
                        GameReplayKey(),
                      ],
                    ),
                  ),
                ),
                _toggleModes[2]
                    ? Slider(
                        label: timeInGame.round().toString(),
                        onChanged: (newVal) => setState(() {
                          setState(() {
                            timeInGame = newVal;
                          });
                        }),
                        min: 0,
                        max: 150, // number of seconds in a game
                        value: timeInGame,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
