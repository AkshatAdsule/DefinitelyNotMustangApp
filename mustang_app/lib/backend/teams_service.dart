import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';

class TeamsService {
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

  Stream<List<Team>> streamTeams() {
    CollectionReference ref =
        _db.collection(_year).document('info').collection('teams');

    return ref.snapshots().map(
        (list) => list.documents.map((doc) => Team.fromSnapshot(doc)).toList());
  }
}
