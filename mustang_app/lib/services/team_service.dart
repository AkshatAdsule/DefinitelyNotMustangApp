import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';

class TeamService {
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

  Future<List<Match>> getMatches(String teamNumber) async {
    QuerySnapshot matchData = await _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .collection('matches')
        .get();
    return matchData.docs.map((e) => Match.fromSnapshot(e)).toList();
  }

  Stream<Team> streamTeam(String teamNumber) {
    return _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .snapshots()
        .map((snap) => Team.fromSnapshot(snap));
  }

  Stream<List<Match>> streamMatches(String teamNumber) {
    CollectionReference ref = _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .collection('matches');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Match.fromSnapshot(doc)).toList());
  }
}
