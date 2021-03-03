import 'package:flutter/material.dart';

class TeamStatistic {
  String teamCode;
  double oprAverage,
      dprAverage,
      ccwmAverage,
      winRateAverage,
      pointContributionAvg,
      oprSlope,
      dprSlope,
      ccwmSlope,
      winrateSlope,
      contributionSlope;
  List<double> oprs = [],
      dprs = [],
      ccwms = [],
      winRates = [],
      contributionPercentages = [];

  List<EventStatistic> events;
  List<YearStats> yearStats = [];

  TeamStatistic(String teamCode, List<EventStatistic> eventStats) {
    this.teamCode = teamCode;
    List<double> currentYearOprs = [],
        currentYearDprs = [],
        currentYearCcwms = [],
        currentYearWinRates = [],
        currentYearPointContributions = [];

    int currentYear = eventStats[1].year;
    for (EventStatistic eventStat in eventStats) {
      if (eventStat.opr > 150 ||
          eventStat.dpr > 150 ||
          eventStat.ccwm > 150 ||
          eventStat.pointContribution > 100 ||
          eventStat.pointContribution < -100) {
        debugPrint(
            'Ignoring ${eventStat.event} for ${eventStat.team} because of a outlier');
      } else {
        if (currentYear == eventStat.year) {
          currentYearOprs.add(eventStat.opr);
          currentYearDprs.add(eventStat.dpr);
          currentYearCcwms.add(eventStat.ccwm);
          currentYearWinRates.add(eventStat.winRate);
          currentYearPointContributions.add(eventStat.pointContribution);
          debugPrint("added year " + currentYear.toString() + " stats");
        } else {
          yearStats.add(
            new YearStats(
                currentYear,
                currentYearOprs,
                currentYearDprs,
                currentYearCcwms,
                currentYearWinRates,
                currentYearPointContributions),
          );
          currentYear = eventStat.year;
          currentYearOprs = [eventStat.opr];
          currentYearDprs = [eventStat.dpr];
          currentYearCcwms = [eventStat.ccwm];
          currentYearWinRates = [eventStat.winRate];
          currentYearPointContributions = [eventStat.pointContribution];
        }
        oprs.add(eventStat.opr);
        dprs.add(eventStat.dpr);
        ccwms.add(eventStat.ccwm);
        winRates.add(eventStat.winRate);
        contributionPercentages.add(eventStat.pointContribution);
      }
    }
    this._calculateAverages();
    this.calculateSlope();
  }

  TeamStatistic.premade(
      {this.teamCode,
      this.oprs,
      this.oprAverage,
      this.oprSlope,
      this.dprs,
      this.dprAverage,
      this.dprSlope,
      this.ccwms,
      this.ccwmAverage,
      this.ccwmSlope,
      this.winRates,
      this.winRateAverage,
      this.winrateSlope,
      this.contributionPercentages,
      this.pointContributionAvg,
      this.contributionSlope,
      this.yearStats});

  TeamStatistic.fromJson(Map<String, dynamic> data);
  void _calculateAverages() {
    oprAverage = oprs.reduce((double a, double b) => a + b) / oprs.length;
    dprAverage = dprs.reduce((a, b) => a + b) / dprs.length;
    ccwmAverage = ccwms.reduce((a, b) => a + b) / ccwms.length;
    winRateAverage = winRates.reduce((a, b) => a + b) / winRates.length;
    debugPrint(contributionPercentages.length.toString());
    double sum = 0;
    for (double contributionPercentage in contributionPercentages) {
      sum += contributionPercentage;
      debugPrint(sum.toString());
    }
    pointContributionAvg = contributionPercentages.reduce((a, b) => a + b) /
        contributionPercentages.length;
  }

  Map<String, dynamic> toJson() {
    return {
      "team": teamCode,
      "oprAverage": oprAverage,
      "dprAverage": dprAverage,
      "ccwmAverage": ccwmAverage,
      "winRateAverage": winRateAverage,
      "pointContributionAverage": pointContributionAvg,
      "oprSlope": oprSlope,
      "dprSlope": dprSlope,
      "ccwmSlope": ccwmSlope,
      "winrateSlope": winrateSlope,
      "contributionSlope": contributionSlope,
      "events": events,
      "yearStatistics": yearStats
    };
  }

  void calculateSlope() {
    int length = yearStats.length;
    if (length <= 0) {
      this.oprSlope = 0;
      this.dprSlope = 0;
      this.ccwmSlope = 0;
      this.winrateSlope = 0;
      this.contributionSlope = 0;
      return;
    }
    int max = length <= 5 ? length : 5;
    double oprSum = 0,
        dprSum = 0,
        ccwmSum = 0,
        winRateSum = 0,
        contributionSum = 0;
    for (var i = 1; i <= max; i++) {
      YearStats currenStats = yearStats[length - 1];
      oprSum += currenStats.avgOpr;
      dprSum += currenStats.avgDpr;
      ccwmSum += currenStats.avgCcwm;
      winRateSum += currenStats.avgWinRate;
      contributionSum += currenStats.avgPointContribution;
    }
    this.oprSlope = oprSum / max;
    this.dprSlope = dprSum / max;
    this.ccwmSlope = ccwmSum / max;
    this.winrateSlope = winRateSum / max;
    this.contributionSlope = contributionSum / max;
    // oprSlope = (yearStats[length - 1].avgOpr +
    //         yearStats[length - 2].avgOpr +
    //         yearStats[length - 3].avgOpr) /
    //     3;
    // dprSlope = (yearStats[length - 1].avgDpr +
    //         yearStats[length - 2].avgDpr +
    //         yearStats[length - 3].avgDpr) /
    //     3;
    // ccwmSlope = (yearStats[length - 1].avgCcwm +
    //         yearStats[length - 2].avgCcwm +
    //         yearStats[length - 3].avgCcwm) /
    //     3;
    // winrateSlope = (yearStats[length - 1].avgWinRate +
    //         yearStats[length - 2].avgWinRate +
    //         yearStats[length - 3].avgWinRate) /
    //     3;
    // contributionSlope = (yearStats[length - 1].avgPointContribution +
    //         yearStats[length - 2].avgPointContribution +
    //         yearStats[length - 3].avgPointContribution) /
    //     3;
  }
}

class EventStatistic {
  String event, team;
  double opr, dpr, ccwm, winRate, pointContribution;
  int year;

  EventStatistic(
      {@required this.event,
      @required this.year,
      @required this.team,
      @required this.opr,
      @required this.dpr,
      @required this.ccwm,
      @required this.winRate,
      @required this.pointContribution});

  Map<String, dynamic> toJson() {
    return {
      "event": this.event,
      "year": this.year,
      "team": this.team,
      "opr": this.opr,
      "dpr": this.dpr,
      "ccwm": this.ccwm,
      "winRate": this.winRate,
      "pointContribution": this.pointContribution
    };
  }
}

class YearStats {
  int year;
  double avgOpr, avgDpr, avgCcwm, avgWinRate, avgPointContribution;

  YearStats(this.year, List<double> oprs, List<double> dprs, List<double> ccwms,
      List<double> winRates, List<double> contributionPercentages) {
    try {
      avgOpr = oprs.reduce((a, b) => a + b) / oprs.length;
      avgDpr = dprs.reduce((a, b) => a + b) / dprs.length;
      avgCcwm = ccwms.reduce((a, b) => a + b) / ccwms.length;
      avgWinRate = winRates.reduce((a, b) => a + b) / winRates.length;
      avgPointContribution = contributionPercentages.reduce((a, b) => a + b) /
          contributionPercentages.length;
    } catch (error) {
      debugPrint(error);
    }
  }

  YearStats.premade(
      {this.year,
      this.avgOpr,
      this.avgCcwm,
      this.avgDpr,
      this.avgWinRate,
      this.avgPointContribution});

  Map<String, dynamic> toJson() {
    return {
      "year": year,
      "oprAverage": avgOpr,
      "dprAverage": avgDpr,
      "ccwmAverage": avgCcwm,
      "winRateAverage": avgWinRate,
      "pointContributionAverage": avgPointContribution,
    };
  }
}
