import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';

class TeamService {
  Firestore _db = Firestore.instance;
  final String _year = DateTime.now().year.toString();
  Future<Team> getTeam(String teamNumber) async {
    return Team.fromSnapshot(await _db
        .collection(_year)
        .document('info')
        .collection('teams')
        .document(teamNumber)
        .get());
  }

  Future<List<Match>> getMatches(String teamNumber) async {
    QuerySnapshot matchData = await _db
        .collection(_year)
        .document('info')
        .collection('teams')
        .document(teamNumber)
        .collection('matches')
        .getDocuments();
    return matchData.documents.map((e) => Match.fromSnapshot(e)).toList();
  }

  Stream<Team> streamTeam(String teamNumber) {
    return _db
        .collection(_year)
        .document('info')
        .collection('teams')
        .document(teamNumber)
        .snapshots()
        .map((snap) => Team.fromSnapshot(snap));
  }

  Stream<List<Match>> streamMatches(String teamNumber) {
    CollectionReference ref = _db
        .collection(_year)
        .document('info')
        .collection('teams')
        .document(teamNumber)
        .collection('matches');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Match.fromSnapshot(doc)).toList());
  }
}
