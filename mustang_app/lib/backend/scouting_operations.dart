import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/components/game_action.dart';
import '../constants/constants.dart';

class ScoutingOperations {
  List<String> teamnames = new List<String>();

  Future<void> updatePitScouting(String teamNumber,
      {bool inner,
      outer,
      bottom,
      rotation,
      position,
      climb,
      leveller,
      String notes,
      drivebaseType}) async {
    await Constants.db.collection('teams').document(teamNumber).updateData({
      'driveBaseType': drivebaseType,
      'innerPort': inner,
      'outerPort': outer,
      'bottomPort': bottom,
      'rotationControl': rotation,
      'positionControl': position,
      'climber': climb,
      'leveller': leveller,
      'notes': notes
    });
  }

  List<Map<String, dynamic>> convertActionsToJson(List<GameAction> actions) {
    return actions.map((action) => action.toJson()).toList();
  }

  Future<void> updateMatchData(
      String teamNumber, String matchNumber, List<GameAction> actions,
      {String matchResult, String finalComments, String allianceColor}) async {
    print('teamNumber: $teamNumber');
    print('matchNumber: $matchNumber');
    await Constants.db
        .collection('teams')
        .document(teamNumber)
        .collection('matches')
        .document(matchNumber)
        .setData({
      'actions': convertActionsToJson(actions),
      'finalComments': finalComments,
      'matchResult': matchResult,
      'allianceColor': allianceColor,
    }).then((value) => print('finish'));
  }

  Future<bool> doesPitDataExist(String teamNumber) async {
    DocumentSnapshot onValue =
        await Constants.db.collection('teams').document(teamNumber).get();

    if (onValue == null) {
      return false;
    } else if (onValue.data == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> doesMatchDataExist(String teamNumber, String matchNumber) async {
    DocumentSnapshot onValue = await Constants.db
        .collection('teams')
        .document(teamNumber)
        .collection('matches')
        .document(matchNumber)
        .get();
    if (onValue == null) {
      return false;
    } else if (onValue.data == null) {
      return false;
    } else {
      return true;
    }
  }
}
