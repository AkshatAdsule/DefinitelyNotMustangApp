import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustang_app/components/blur_overlay.dart';
import 'package:mustang_app/components/game_action.dart';
import 'package:mustang_app/components/selectable_zone_grid.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/exports/pages.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/header.dart';
import 'defense_scouting.dart';
import 'offense_scouting.dart';

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

  void addAction(ActionType type, BuildContext context) {
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
      return;
    }
    _actions.add(action);
    print(action);
  }

  void setClimb(int millisecondsElapsed) {
    print('SLIDER LAST CHANGED $millisecondsElapsed');
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
          finishGame: this.finishGame,
          addAction: this.addAction,
          undo: this.undo,
          setClimb: this.setClimb,
          allianceColor: _allianceColor,
        ),
        DefenseScouting(
          toggleMode: this.toggleMode,
          stopwatch: _stopwatch,
          zoneGrid: _defenseZoneGrid,
          finishGame: this.finishGame,
          addAction: this.addAction,
          undo: this.undo,
          allianceColor: _allianceColor,
        ),
      ],
    );

    return Scaffold(
      appBar: Header(context, 'Map Scouting'),
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
