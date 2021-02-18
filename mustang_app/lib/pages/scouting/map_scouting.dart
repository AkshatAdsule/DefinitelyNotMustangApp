import 'package:flutter/material.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/selectable_zone_grid.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/exports/pages.dart';
import '../../components/header.dart';
import 'defense_scouting.dart';
import 'offense_scouting.dart';
import '../../components/game_buttons.dart' as game_button;

class MapScouting extends StatefulWidget {
  static const String route = '/MapScouter';
  String _teamNumber, _matchNumber, _allianceColor;

  MapScouting({String teamNumber, String matchNumber, String allianceColor}) {
    _teamNumber = teamNumber;
    _matchNumber = matchNumber;
    _allianceColor = allianceColor;
  }

  @override
  _MapScoutingState createState() =>
      _MapScoutingState(_teamNumber, _matchNumber, _allianceColor);
}

class _MapScoutingState extends State<MapScouting> {
  bool _onOffense, _startedScouting;
  Stopwatch _stopwatch;
  String _teamNumber, _matchNumber, _allianceColor;
  ZoneGrid _offenseZoneGrid, _defenseZoneGrid;
  List<GameAction> _actions;
  OffenseScouting offenseScouting;
  DefenseScouting defenseScouting;
  int _sliderLastChanged;

  _MapScoutingState(this._teamNumber, this._matchNumber, this._allianceColor);

  @override
  void initState() {
    super.initState();
    _onOffense = true;
    _startedScouting = false;
    _stopwatch = new Stopwatch();
    _offenseZoneGrid = SelectableZoneGrid(UniqueKey(), (int x, int y) {});
    _defenseZoneGrid = SelectableZoneGrid(UniqueKey(), (int x, int y) {});

    _actions = [];
    _sliderLastChanged = 0;
  }

  void toggleMode() {
    setState(() {
      _onOffense = !_onOffense;
    });
  }

  // -1 = no loc, 0 = all good
  int addAction(ActionType type, BuildContext context) {
    int now = _stopwatch.elapsedMilliseconds;
    int x = _onOffense ? _offenseZoneGrid.x : _defenseZoneGrid.x;
    int y = _onOffense ? _offenseZoneGrid.y : _defenseZoneGrid.y;
    bool hasSelected = _onOffense
        ? _offenseZoneGrid.hasSelected
        : _defenseZoneGrid.hasSelected;
    GameAction action;
    if (hasSelected && GameAction.requiresLocation(type)) {
      action = new GameAction(type, now.toDouble(), x.toDouble(), y.toDouble());
    } else if (!GameAction.requiresLocation(type)) {
      action = GameAction.other(type, now.toDouble());
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No location selected"),
        duration: Duration(milliseconds: 1500),
      ));
      return -1;
    }
    _actions.add(action);
    print(action);
    return 0;
  }

  void setClimb(int millisecondsElapsed) {
    _sliderLastChanged = millisecondsElapsed;
  }

  void finishGame(BuildContext context) {
    _actions.add(
      GameAction(
        ActionType.OTHER_CLIMB,
        _sliderLastChanged.toDouble() ?? 120000,
        _offenseZoneGrid.x.toDouble(),
        _offenseZoneGrid.y.toDouble(),
      ),
    );
    Navigator.pushNamed(context, MatchEndScouter.route, arguments: {
      'teamNumber': _teamNumber,
      'matchNumber': _matchNumber,
      'actions': _actions,
      'allianceColor': _allianceColor,
    });
  }

  GameAction undo() {
    if (_actions.length > 0) {
      return _actions.removeLast();
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    Widget scoutingMode = IndexedStack(
      index: _onOffense ? 0 : 1,
      children: [
        OffenseScouting(
          toggleMode: this.toggleMode,
          stopwatch: _stopwatch,
          zoneGrid: _offenseZoneGrid,
          addAction: this.addAction,
          setClimb: this.setClimb,
          allianceColor: _allianceColor,
        ),
        DefenseScouting(
          toggleMode: this.toggleMode,
          stopwatch: _stopwatch,
          zoneGrid: _defenseZoneGrid,
          addAction: this.addAction,
          allianceColor: _allianceColor,
        ),
      ],
    );

    Widget _undoButton = Container(
        margin: EdgeInsets.only(
          right: 10,
        ),
        child: game_button.ScoutingButton(
            style: game_button.ButtonStyle.RAISED,
            type: game_button.ButtonType.PAGEBUTTON,
            onPressed: () => () {
                  GameAction action = undo();
                  if (action == null) {
                    return;
                  }
                  switch (action.action) {
                    case ActionType.OTHER_WHEEL_ROTATION:
                      offenseScouting.setRotationControl(false);
                      break;
                    case ActionType.OTHER_WHEEL_POSITION:
                      offenseScouting.setPositionControl(false);
                      break;
                    case ActionType.OTHER_CROSSED_INITIATION_LINE:
                      setState(() {
                        offenseScouting.setInitiationLine(false);
                      });
                      break;
                    default:
                      break;
                  }
                },
            text: "UNDO"));

    Widget _finishGameButton = _stopwatch.elapsedMilliseconds > 150000
        ? Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: game_button.ScoutingButton(
              style: game_button.ButtonStyle.RAISED,
              type: game_button.ButtonType.ELEMENT,
              onPressed: () => finishGame(context),
              text: 'Finish Game',
            ))
        : Container();

    return Scaffold(
      appBar: Header(context, 'Map Scouting',
          buttons: [_undoButton, _finishGameButton]),
      body: Container(
        child: !_startedScouting
            ? BlurOverlay(
                background: scoutingMode,
                text: Text('Start'),
                onEnd: () {
                  setState(() {
                    _startedScouting = true;
                    _stopwatch.start();
                  });
                },
              )
            : scoutingMode,
      ),
      // bottomNavigationBar: BottomNavBar(context),
      // TODO: Make sure that bottom nav appears when the end game notes button
      // is clicked or when the undo button is held down
    );
  }
}
