import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';

class TeamsService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _year = DateTime.now().year.toString();
  Future<Team> getTeam(String teamNumber) async {
    return Team.fromSnapshot(await _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .get());
  }

  Stream<List<Team>> streamTeams() {
    CollectionReference ref =
        _db.collection(_year).doc('info').collection('teams');

    return ref
        .snapshots()
        .map((list) => list.docs.map((doc) => Team.fromSnapshot(doc)).toList());
  }
}
