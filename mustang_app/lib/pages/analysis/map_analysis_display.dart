import 'package:flutter/material.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/services/keivna_data_analyzer.dart';
import 'package:mustang_app/services/keivna_map_analyzer.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/map/game_map.dart';
import 'package:mustang_app/components/analysis/game_replay_key.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mustang_app/components/analysis/map_analysis_key.dart';
import 'package:mustang_app/components/inputs/mode_toggle.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/components/inputs/select.dart';
import 'package:mustang_app/components/utils/youtube_embed.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/utils/get_statistics.dart';
import 'package:provider/provider.dart';
import '../../services/analyzer.dart';

// ignore: must_be_immutable
//Represents the entire page of map analyses, holds tabs for accuracy map, shooting map, game replay map
class MapAnalysisDisplay extends StatelessWidget {
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
      value: TeamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: TeamService.streamMatches(_teamNumber),
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
  // Analyzer myAnalyzer;
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
    false,
  ];
  double timeInGame = 0;
  GameMap gameMap;
  String selectedMatch = "ALL";
  ActionType selectedActionType = ActionType.ALL;
  String teamNumber;
  Map<String, String> _videoLinks;

  _MapAnalysisDisplayState(this.teamNumber) {
    // myAnalyzer = new Analyzer();
    initVideoLinks();
  }

  @override
  void initState() {
    super.initState();
  }

  void initVideoLinks() async {
    //TODO use event key properly
    Map<String, String> links =
        (await GetStatistics.getInstance().getMatchVideos(
      'frc' + teamNumber,
      Event(eventCode: '2018utwv'),
    ));
    setState(() {
      _videoLinks = links;
    });
  }

  // int _getScoringColorValue(ActionType actionType, int x, int y) {
  //   double totalNumGames = myAnalyzer.totalNumGames().toDouble();
  //   double ptsAtZone =
  //       myAnalyzer.calcPtsAtZone(actionType, x.toDouble(), y.toDouble()) /
  //           totalNumGames;

  //   double ptsAtZonePerGame = ptsAtZone / totalNumGames;
  //   double colorValue =
  //       ((ptsAtZonePerGame / GameConstants.maxPtValuePerZonePerGame) * 900);
  //   int lowerBound = 0, upperBound = 0;
  //   if (!colorValue.isNaN && colorValue.isFinite) {
  //     lowerBound = (colorValue ~/ 100) * 100; //lower bound of 100
  //     upperBound = (colorValue ~/ 100 + 1) * 100; //upper bound
  //   }

  //   int returnVal = (colorValue - lowerBound > upperBound - colorValue)
  //       ? upperBound
  //       : lowerBound;
  //   if (returnVal > 900) {
  //     return 900;
  //   }
  //   debugPrint("scoring color value: " + returnVal.toString());
  //   return returnVal;
  // }

  // int _getAccuracyColorValue(ActionType actionType, int x, int y) {
  //   double zoneAccuracyOutOf1 = myAnalyzer.calcShotAccuracyAtZone(
  //       actionType, x.toDouble(), y.toDouble());

  //   double zoneAccuracyOutOf900 = zoneAccuracyOutOf1 * 900;
  //   if (!zoneAccuracyOutOf900.isInfinite && !zoneAccuracyOutOf900.isNaN) {
  //     int a = (zoneAccuracyOutOf900 ~/ 100) * 100; //lower bound of 100
  //     int b = (zoneAccuracyOutOf900 ~/ 100 + 1) * 100; //upper bound
  //     int returnVal =
  //         (zoneAccuracyOutOf900 - a > b - zoneAccuracyOutOf900) ? b : a;
  //     debugPrint("accuracy color value: " + returnVal.toString());
  //     return returnVal;
  //   } else {
  //     debugPrint("accuracy color value: 0");
  //     return 0;
  //   }
  // }

// game replay stuff
  // List<Color> _getColorCombo(BuildContext context, int x, int y) {
  //   GameAction curr;
  //   List<GameAction> currActions = getAllMatchActions(context)
  //       .where((element) => element.timeStamp > timeInGame * 1000 - 5000)
  //       .where((element) => element.timeStamp < timeInGame * 1000 + 1000)
  //       .toList();
  //   for (GameAction currentAction in currActions) {
  //     if (currentAction.x == x && currentAction.y == y) {
  //       curr = currentAction;
  //       break;
  //     }
  //   }
  //   if (curr == null) return [Colors.green[0], Colors.yellow[0]];

  //   List<Color> gradientCombo = [];
  //   String actionType = curr.actionType.toString();

  //   for (List<Object> shade in actionRelatedColors)
  //     if (actionType.contains(shade[0])) gradientCombo.add(shade[1]);

  //   if (gradientCombo.length < 2) {
  //     if (actionType.contains("FOUL")) {
  //       gradientCombo.add(Colors.yellow[600]);
  //     } else if (actionType.contains("OTHER")) {
  //       gradientCombo.add(Colors.orange[600]);
  //     }
  //   }

  //   return gradientCombo;
  // }

  // List<GameAction> getAllMatchActions(BuildContext context) {
  //   if (selectedMatch == "ALL") {
  //     return Provider.of<List<Match>>(context)
  //         .map((e) => e.actions)
  //         .reduce((value, element) => [...value, ...element]);
  //   }
  //   return Provider.of<List<Match>>(context)
  //       .where((element) => element.matchNumber == selectedMatch)
  //       .map((e) => e.actions)
  //       .reduce((value, element) => [...value, ...element]);
  // }

  Widget _getCell(BuildContext context, int x, int y, bool isSelected,
      double cellWidth, double cellHeight) {
            List<Match> matches = Provider.of<List<Match>>(context);

    int ind = _toggleModes.indexOf(true);
    switch (ind) {
      case 0:
        {
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
                color: (Colors.green[
                        KeivnaMapAnalyzer.getShootingPointsColorValueAtLocation(
                                matches, x, y)] ==
                        null)
                        //     KeivnaMapAnalyzer.getScoringColorValueAtLocation(
                        //         selectedActionType, x, y)] ==
                        // null)
                    ? null
                    : Colors.green[
                            KeivnaMapAnalyzer.getShootingPointsColorValueAtLocation(
                                matches, x, y)]
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
                // color: (Colors.green[KeivnaMapAnalyzer.getAccuracyColorValue(
                //             selectedActionType, x, y)] ==
                //         null)
                //     ? null
                //     : Colors.green[KeivnaMapAnalyzer.getAccuracyColorValue(
                //             selectedActionType, x, y)]
                //         .withOpacity(0.7)
                ),
          );
        }
      case 2:
        {
          return Container(
            width: cellWidth,
            height: cellHeight,
            decoration: (x != 0 && y != 0)
                ? BoxDecoration(
                    gradient: RadialGradient(
                      colors: KeivnaMapAnalyzer.getColorCombo(
                          context, selectedMatch, timeInGame, x, y),
                    ),
                  )
                : BoxDecoration(color: Colors.transparent),
          );
        }
      case 3:
        {
          return Container();
        }
      default:
        {
          return Container();
        }
    }
  }

  // TODO: CHANGE THIS TO BE ACTUALLY EXTRACTED FROM THE MATCH NUMBER
  String getVideoLink() {
    return "https://www.youtube.com/watch?v=flUVtcakEDA";
  }

  String _getMatchKey(BuildContext context) {
    String key = selectedMatch == "ALL" ||
            Provider.of<List<Match>>(context)
                    .where((element) => element.matchNumber == selectedMatch)
                    .length ==
                0
        ? Provider.of<List<Match>>(context).first.matchKey
        : Provider.of<List<Match>>(context)
            .where((element) => element.matchNumber == selectedMatch)
            .first
            .matchKey;

    return key;
  }

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<Team>(context);
    List<Match> matches = Provider.of<List<Match>>(context);
    // if (!myAnalyzer.initialized) {
    //   myAnalyzer.init(
    //     Provider.of<Team>(context),
    //     Provider.of<List<Match>>(context),
    //   );
    //   setState(() {});
    // }

    return Screen(
      title: 'Map Analysis for Team: ' + (team != null ? team.teamNumber : ""),
      includeBottomNav: false,
      child: Container(
        child:
            // Column(
            //   children: [
            GameMap(
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
              createOverlay: (constraints, selections, cellWidth, cellHeight) {
            return _toggleModes[3]
                ? [
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: _videoLinks != null &&
                              Provider.of<List<Match>>(context).length > 0
                          ? YoutubeEmbed(
                              _videoLinks[_getMatchKey(context)],
                            )
                          : Container(),
                    ),
                  ]
                : [];
          }),
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
                        icon: FontAwesomeIcons.trophy,
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
                      ModeToggleChild(
                        icon: FontAwesomeIcons.video,
                        isSelected: _toggleModes[3],
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
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              minHeight: 60.0),
                          alignment: Alignment.center,
                          child: Text(
                            "idk what to put here \n\n so enjoy the video \n\n if its there :)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1,
                            ),
                          ),
                        ),
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
