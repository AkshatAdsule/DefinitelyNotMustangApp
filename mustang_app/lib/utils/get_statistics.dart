import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_statistic.dart';
import 'package:http/http.dart' as http;

class Event {
  String eventCode;
  int year;

  Event({this.eventCode, this.year});

  Map<String, dynamic> toJson() {
    return {"eventCode": eventCode, "year": year};
  }
}

class GetStatistics {
  static const Map<String, String> _header = {
    "X-TBA-Auth-Key":
        "JAuW8W8YRGoCk0zREOgnqkGPtfUX5UAfHvd6Ze1ixcPUB3F2tpwXV24l7qoUUnqL"
  };
  FirebaseFirestore _firestore;
  CollectionReference _teams;
  GetStatistics getStatistics;

  Future<void> _firebaseInit() async {
    _firestore = FirebaseFirestore.instance;
    _teams = _firestore.collection('team-statistics');
  }

  GetStatistics() {
    _firebaseInit();
  }

  /// Returns array of of event codes that a team participated in.
  Future<List<Event>> getEvents(String teamCode) async {
    var response;
    List<Event> events = [];
    await http
        .get("https://www.thebluealliance.com/api/v3/team/$teamCode/events",
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);

    for (var event in resJson) {
      events.add(new Event(eventCode: event['key'], year: event['year']));
    }
    return events;
  }

  // Returns array of team codes from an event
  Future<List> getTeams(String eventCode) async {
    var response;
    List<String> teams = [];
    await http
        .get("https://www.thebluealliance.com/api/v3/event/$eventCode/teams",
            headers: _header)
        .then((res) => response = res.body);
    var resJson = jsonDecode(response);

    for (var team in resJson) {
      teams.add(team['key']);
    }
    return teams;
  }

// Returns array of match scores from the alliance that a team participated in at an event
  Future<List> getMatchScores(String teamCode, Event event) async {
    var response;
    List<int> matchScores = [];
    await http
        .get(
            "https://www.thebluealliance.com/api/v3/team/$teamCode/event/${event.eventCode}/matches/simple",
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
    //debugPrint(matchScores);
    return matchScores;
  }

// Returns the average team score at an event
  Future<double> getAvgTeamScore(String eventCode) async {
    var response;
    int sum = 0;
    await http
        .get(
            "https://www.thebluealliance.com/api/v3/event/$eventCode/matches/simple",
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
            "https://www.thebluealliance.com/api/v3/team/$teamCode/event/$eventCode/matches/simple",
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
    var _response;
    await http
        .get(
            'https://www.thebluealliance.com/api/v3/event/${event.eventCode}/oprs',
            headers: _header)
        .then((res) => _response = res.body);
    try {
      var resJson = jsonDecode(_response);
      double opr = resJson['oprs'][team];
      double dpr = resJson['dprs'][team];
      double ccwm = resJson['ccwms'][team];
      double winRate = await getWinRate(team, event.eventCode);
      double contributionPercentage = await getPointContribution(team, event);
      //debugPrint(contributionPercentage);

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
        return new EventStatistic(
            team: team,
            event: event.eventCode,
            year: event.year,
            opr: opr,
            dpr: dpr,
            ccwm: ccwm,
            winRate: winRate,
            pointContribution: contributionPercentage);
      } else {
        throw 'Could not find stats for $team at ${event.eventCode}';
      }
    } catch (e) {
      throw 'Could not find stats for $team at ${event.eventCode}';
    }
  }

/*
  List<double> getPointContribution(String teamCode) {
    List<Event> events = getEvents(teamCode) as List<Event>;
    List<double> contributionPercentages;
    for (Event event in events) {
      List<double> matchScores = getMatchScores(teamCode, event.eventCode) as List<double>;
      EventStatistic eventStat = getEventStats(teamCode, event) as EventStatistic;
      double opr = eventStat.opr;
      double sum = 0;
      for (double allianceScore in matchScores) {
        sum += opr/allianceScore;
      }
      contributionPercentages.add((sum/matchScores.length) * 100);
    }
    return contributionPercentages;
  }
  */

  Future<double> getPointContribution(String teamCode, Event event) async {
    var response;
    double contributionPercentage;
    await http
        .get(
            'https://www.thebluealliance.com/api/v3/event/${event.eventCode}/oprs',
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
    if (doc.exists) {
      var docData = doc.data();
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
                  year: new DateTime(s["year"]),
                  avgOpr: s["oprAverage"] as double,
                  avgDpr: s["dprAverage"] as double,
                  avgCcwm: s["ccwmAverage"] as double,
                  avgWinRate: s["winRateAverage"] as double,
                  avgPointContribution:
                      s["pointContributionAverage"] as double),
            )
            .toList(),
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
      _teams.doc(team).set(jsonDecode(jsonEncode(teamStatistic)));
      return teamStatistic;
    }
  }
}
