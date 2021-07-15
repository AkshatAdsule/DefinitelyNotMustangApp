import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mustang_app/constants/constants.dart';

import 'package:mustang_app/models/team_statistic.dart';
import 'package:mustang_app/utils/stream_event.dart';

class Event {
  String eventCode;
  String eventType;
  int year;

  Event({this.eventCode, this.year, this.eventType});

  Map<String, dynamic> toJson() {
    return {"eventCode": eventCode, "year": year, "eventType": eventType};
  }
}

class GetStatistics {
  static const Map<String, String> _header = {
    "X-TBA-Auth-Key":
        "JAuW8W8YRGoCk0zREOgnqkGPtfUX5UAfHvd6Ze1ixcPUB3F2tpwXV24l7qoUUnqL"
  };
  static const String API_PREFIX = 'https://www.thebluealliance.com/api/v3';
  static GetStatistics _instance;

  static StreamController<StreamEvent> _eventStreamController =
      new StreamController.broadcast();
  static Stream<StreamEvent> get eventStream => _eventStreamController.stream;

  FirebaseFirestore _firestore;
  CollectionReference _teams;

  static GetStatistics getInstance() {
    _instance = _instance ?? new GetStatistics._();
    return _instance;
  }

  static const Map<String, double> eventTypeWeightings = {
    "Regional": 1.0,
    "Championship Division": 2.0,
    "Offseason": 1.0,
    "District Championship": 1.5,
    "District": 1.2,
    "Championship Finals": 1.5,
    "Preseason": 1.0,
    // Don't count remote events
    "Remote": 0.0
  };

  Future<void> _firebaseInit() async {
    _firestore = FirebaseFirestore.instance;
    _teams = _firestore.collection('team-statistics');
  }

  GetStatistics._() {
    _firebaseInit();
  }

  /// Returns array of of event codes that a team participated in.
  Future<List<Event>> getEvents(String teamCode) async {
    var response;
    List<Event> events = [];
    await http
        .get(Uri.parse("$API_PREFIX/team/$teamCode/events"), headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);

    for (var event in resJson) {
      if (eventTypeWeightings[event['event_type_string']] == null) {
        print(
            "------------------- FAILED: ${event['event_type_string']} -------------------");
      }
      events.add(new Event(
          eventCode: event['key'],
          year: event['year'],
          eventType: event['event_type_string']));
    }
    _eventStreamController.add(
      StreamEvent(
          message: "Got statistics for $teamCode", type: MessageType.INFO),
    );
    return events;
  }

  // Returns array of team codes from an event
  Future<List> getTeams(String eventCode) async {
    var response;
    List<String> teams = [];
    await http
        .get(Uri.parse("$API_PREFIX/event/$eventCode/teams"), headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);

    for (var team in resJson) {
      teams.add(team['key']);
    }
    _eventStreamController.add(
      StreamEvent(message: "Got teams for $eventCode", type: MessageType.INFO),
    );
    return teams;
  }

// Returns array of match scores from the alliance that a team participated in at an event
  Future<List> getMatchScores(String teamCode, Event event) async {
    _eventStreamController.add(
      StreamEvent(
        message: "Getting match scores for $teamCode at ${event.eventCode}",
        type: MessageType.INFO,
      ),
    );
    var response;
    List<int> matchScores = [];
    await http
        .get(
            Uri.parse(
                "$API_PREFIX/team/$teamCode/event/${event.eventCode}/matches/simple"),
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);

    for (var match in resJson) {
      var alliance = match['alliances'];
      var red = alliance['red'];
      var teams = red['team_keys'];
      var found = false;
      for (var team in teams) {
        if (team == teamCode) {
          //debugPrint("red alliance");
          matchScores.add(red['score']);
          //debugPrint(red['score']);
          found = true;
        }
      }
      if (!found) {
        var blue = alliance['blue'];
        var teams = blue['team_keys'];
        for (var team in teams) {
          if (team == teamCode) {
            //debugPrint("blue alliance");
            matchScores.add(blue['score']);
            //debugPrint(blue['score']);
            found = true;
          }
        }
      }
    }
    _eventStreamController.add(
      StreamEvent(
        message: "Got match scores for $teamCode at ${event.eventCode}",
        type: MessageType.INFO,
      ),
    );
    //debugPrint(matchScores);
    return matchScores;
  }

// Returns the average team score at an event
  Future<double> getAvgTeamScore(String eventCode) async {
    var response;
    int sum = 0;
    await http
        .get(Uri.parse("$API_PREFIX/event/$eventCode/matches/simple"),
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);
    for (var match in resJson) {
      var alliance = match['alliances'];
      var red = alliance['red'];
      sum += red['score'];
      var blue = alliance['blue'];
      sum += blue['score'];
    }
    int numOfMatches = resJson.length;
    return sum / (numOfMatches * 6);
  }

  Future<double> getWinRate(String teamCode, String eventCode) async {
    var response;
    await http
        .get(
            Uri.parse(
                "$API_PREFIX/team/$teamCode/event/$eventCode/matches/simple"),
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);
    String allianceColor;
    int numOfWins = 0;
    for (var match in resJson) {
      var alliance = match['alliances'];
      var blue = alliance['blue'];
      var teams = blue['team_keys'];
      for (var team in teams) {
        if (team == teamCode) {
          allianceColor = "blue";
        }
      }
      if (allianceColor != null) {
        var red = alliance['red'];
        var teams = red['team_keys'];
        for (var team in teams) {
          if (team == teamCode) {
            allianceColor = "red";
          }
        }
      }
      String winningAlliance = match['winning_alliance'];
      if (allianceColor == winningAlliance) {
        numOfWins++;
      }
    }
    return (numOfWins / resJson.length) * 100;
  }

  /// Returns a EventStatistic of the OPR, DPR and CCWM for a team at an event
  Future<EventStatistic> getEventStats(String team, Event event) async {
    // _eventStreamController.add(
    //   StreamEvent(
    //     message: "Getting event statistics for $team at ${event.eventCode}",
    //     type: MessageType.INFO,
    //   ),
    // );
    var _response;
    await http
        .get(Uri.parse('$API_PREFIX/event/${event.eventCode}/oprs'),
            headers: _header)
        .then((res) => _response = res.body);
    try {
      var resJson = jsonDecode(_response);
      double opr = resJson['oprs'][team];
      double dpr = resJson['dprs'][team];
      double ccwm = resJson['ccwms'][team];
      double scale = GetStatistics.eventTypeWeightings[event.eventType] == null
          ? 1
          : GetStatistics.eventTypeWeightings[event.eventType];
      double winRate = await getWinRate(team, event.eventCode);
      double contributionPercentage = await getPointContribution(team, event);

      // Make sure result is not empty object
      if (opr != null) {
        // debugPrint('$team at ${event.eventCode}  ${{
        //   "opr": opr,
        //   "dpr": dpr,
        //   "ccwm": ccwm,
        //   "winRate": winRate,
        //   "pointContribution": contributionPercentage
        // }}');
        // return {"opr": opr, "dpr": dpr, "ccwm": ccwm, "winRate": winRate};
        _eventStreamController.add(
          StreamEvent(
            message: "Got event statistics for $team at ${event.eventCode}",
            type: MessageType.INFO,
          ),
        );
        return new EventStatistic(
            team: team,
            event: event.eventCode,
            year: event.year,
            opr: opr * scale,
            dpr: dpr * scale,
            ccwm: ccwm * scale,
            winRate: winRate,
            pointContribution: contributionPercentage);
      } else {
        _eventStreamController.add(
          StreamEvent(
            message: "Could not find stats for $team at ${event.eventCode}",
            type: MessageType.WARNING,
          ),
        );
        throw 'Could not find stats for $team at ${event.eventCode}';
      }
    } catch (e) {
      _eventStreamController.add(
        StreamEvent(
          message: "Could not find stats for $team at ${event.eventCode}",
          type: MessageType.WARNING,
        ),
      );
      throw 'Could not find stats for $team at ${event.eventCode}';
    }
  }

  Future<double> getPointContribution(String teamCode, Event event) async {
    var response;
    double contributionPercentage;
    await http
        .get(Uri.parse('$API_PREFIX/event/${event.eventCode}/oprs'),
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);
    double opr = resJson['oprs'][teamCode];
    //debugPrint(opr);
    List<dynamic> matchScores = await getMatchScores(teamCode, event);
    //debugPrint(matchScores);
    double sum = 0;
    for (dynamic allianceScore in matchScores) {
      //debugPrint(sum);
      if (allianceScore != 0) sum += opr / allianceScore;
    }
    contributionPercentage = (sum / matchScores.length) * 100;
    //debugPrint(contributionPercentage);
    return contributionPercentage;
  }

  /// Returns a new TeamStatistic object, which contains the average OPR, DPR, and CCWM along with a list of all OPRs, CCWMs, and DPRs
  Future<TeamStatistic> getCumulativeStats(String team) async {
    List<EventStatistic> eventStats = [];
    var doc = await _teams.doc(team).get();
    Map<String, dynamic> docData = doc.data();

    if (doc.exists &&
        docData["DATA_VERSION"] == Constants.DATA_ANALYSIS_DATA_VERSION &&
        false) {
      _eventStreamController.add(
        StreamEvent(
          message: "Computing stats for $team",
          type: MessageType.INFO,
        ),
      );
      Map<String, dynamic> dataMap =
          docData.map((key, value) => MapEntry(key, value));
      TeamStatistic teamStatistic = new TeamStatistic.premade(
        teamCode: team,
        oprAverage: dataMap['oprAverage'] as double,
        oprSlope: dataMap['oprSlope'] as double,
        dprAverage: dataMap['dprAverage'] as double,
        dprSlope: dataMap['dprSlope'] as double,
        ccwmAverage: dataMap['ccwmAverage'] as double,
        ccwmSlope: dataMap['ccwmSlope'] as double,
        winRateAverage: dataMap['winRateAverage'] as double,
        winrateSlope: dataMap['winrateSlope'] as double,
        pointContributionAvg: dataMap['pointContributionAverage'] as double,
        contributionSlope: dataMap['contributionSlope'] as double,
        yearStats: dataMap['yearStatistics']
            .map<YearStats>(
              (s) => new YearStats.premade(
                year: DateTime.parse(s["year"]),
                avgOpr: s["oprAverage"] as double,
                avgDpr: s["dprAverage"] as double,
                avgCcwm: s["ccwmAverage"] as double,
                avgWinRate: s["winRateAverage"] as double,
                avgPointContribution: s["pointContributionAverage"] as double,
              ),
            )
            .toList(),
      );
      _eventStreamController.add(
        StreamEvent(
          message: "Got cached stats for $team",
          type: MessageType.INFO,
        ),
      );
      return teamStatistic;
    } else {
      List<Event> events = await getEvents(team);
      for (Event event in events) {
        try {
          EventStatistic eventStat = await getEventStats(team, event);
          eventStats.add(eventStat);
        } catch (error) {
          debugPrint(error);
        }
      }
      TeamStatistic teamStatistic = new TeamStatistic(team, eventStats);
      _teams.doc(team).set(teamStatistic.toJson());
      _eventStreamController.add(
        StreamEvent(
          message: "Got computed stats for $team",
          type: MessageType.INFO,
        ),
      );
      return teamStatistic;
    }
  }

  static Future<Map<String, String>> getMatchVideos(
      String teamNumber, Event event) async {
    Map<String, String> matchLinks = {};

    try {
      http.Response res = await http.get(
          Uri.parse(
              '$API_PREFIX/team/$teamNumber/event/${event.eventCode}/matches'),
          headers: {..._header, 'accept': 'application/json'});

      var resJson = jsonDecode(res.body);
      List<dynamic> json = resJson as List;

      for (int i = 0; i < json.length; i++) {
        dynamic matchdata = json[i];
        String matchKey = matchdata['match_number'].toString() +
            '-' +
            matchdata['comp_level'];
        List<dynamic> videos = matchdata['videos'] as List;
        for (int j = 0; j < videos.length; j++) {
          matchLinks[matchKey] = videos[j]['key'];
        }
      }
      return matchLinks;
    } catch (error) {
      print('error: $error');
      return matchLinks;
    }
  }
}
