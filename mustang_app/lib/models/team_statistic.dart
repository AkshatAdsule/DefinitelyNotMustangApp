import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/models/robot.dart';

class TeamStatistic {
  String teamCode;
  num oprAverage,
      dprAverage,
      ccwmAverage,
      winRateAverage,
      pointContributionAvg,
      oprSlope,
      dprSlope,
      ccwmSlope,
      winrateSlope,
      contributionSlope;
  List<num> oprs = [],
      dprs = [],
      ccwms = [],
      winRates = [],
      contributionPercentages = [];

  List<EventStatistic> events;
  List<YearStats> yearStats = [];

  TeamStatistic(String teamCode, List<EventStatistic> eventStats) {
    this.teamCode = teamCode;
    this.events = eventStats;
    List<num> currentYearOprs = [],
        currentYearDprs = [],
        currentYearCcwms = [],
        currentYearWinRates = [],
        currentYearPointContributions = [];

    DateTime currentYear = new DateTime(eventStats[0].year);
    for (EventStatistic eventStat in eventStats) {
      if (eventStat.opr > 150 ||
          eventStat.dpr > 150 ||
          eventStat.ccwm > 150 ||
          eventStat.pointContribution > 100 ||
          eventStat.pointContribution < -100) {
        // debugPrint(
        //     'Ignoring ${eventStat.event} for ${eventStat.team} because of a outlier');
      } else {
        if (currentYear.year == eventStat.year) {
          currentYearOprs.add(eventStat.opr);
          currentYearDprs.add(eventStat.dpr);
          currentYearCcwms.add(eventStat.ccwm);
          currentYearWinRates.add(eventStat.winRate);
          currentYearPointContributions.add(eventStat.pointContribution);
          // debugPrint("added year " + currentYear.toString() + " stats");
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
          currentYear = new DateTime(eventStat.year);
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

  TeamStatistic.premade({
    this.teamCode,
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
    this.yearStats,
  });

  TeamStatistic.fromJson(Map<String, dynamic> data);
  void _calculateAverages() {
    oprAverage = oprs.reduce((num a, num b) => a + b) / oprs.length;
    dprAverage = dprs.reduce((a, b) => a + b) / dprs.length;
    ccwmAverage = ccwms.reduce((a, b) => a + b) / ccwms.length;
    winRateAverage = winRates.reduce((a, b) => a + b) / winRates.length;
    pointContributionAvg = contributionPercentages.reduce((a, b) => a + b) /
        contributionPercentages.length;
  }

  Map<String, dynamic> toJson() {
    return {
      "DATA_VERSION": Constants.DATA_ANALYSIS_DATA_VERSION,
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
      "events": events.map((e) => e.toJson()).toList(),
      "yearStatistics": yearStats.map((e) => e.toJson()).toList(),
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
    num oprSum = 0,
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
  }
}

class PitScoutingStatistic {
  String teamCode;
  DriveBaseType driveBaseType;
  List<String> autonPaths;
  List<ShootingCapability> shootingCapabilities;
  int maxGamePieces;
  ClimbCapability climbCapability;
  String comments;

  PitScoutingStatistic.premade({
    this.teamCode,
    this.driveBaseType,
    this.autonPaths,
    this.shootingCapabilities,
    this.maxGamePieces, 
    this.climbCapability,
    this.comments
  });

  Map<String, dynamic> toJson() {
    return {
      "team": teamCode,
      "driveBaseType": driveBaseType,
      "autonPaths": autonPaths,
      "shootingCapabilities": shootingCapabilities,
      "maxGamePieces": maxGamePieces,
      "climbCapability": climbCapability,
      "additionalComments": comments
    };
  }
}

class EventStatistic {
  String event, team;
  num opr, dpr, ccwm, winRate, pointContribution;
  int year;

  EventStatistic(
      {this.event,
      this.year,
      this.team,
      this.opr,
      this.dpr,
      this.ccwm,
      this.winRate,
      this.pointContribution});

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
  DateTime year;
  num avgOpr, avgDpr, avgCcwm, avgWinRate, avgPointContribution;

  YearStats(this.year, List<num> oprs, List<num> dprs, List<num> ccwms,
      List<num> winRates, List<num> contributionPercentages) {
    try {
      avgOpr = oprs.reduce((a, b) => a + b) / oprs.length;
      avgDpr = dprs.reduce((a, b) => a + b) / dprs.length;
      avgCcwm = ccwms.reduce((a, b) => a + b) / ccwms.length;
      avgWinRate = winRates.reduce((a, b) => a + b) / winRates.length;
      avgPointContribution = contributionPercentages.reduce((a, b) => a + b) /
          contributionPercentages.length;
    } catch (error) {
      // debugPrint(error);
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
      "year": year.toString(),
      "oprAverage": avgOpr,
      "dprAverage": avgDpr,
      "ccwmAverage": avgCcwm,
      "winRateAverage": avgWinRate,
      "pointContributionAverage": avgPointContribution,
    };
  }
}
