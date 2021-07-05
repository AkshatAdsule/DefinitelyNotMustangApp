import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/user.dart';

class UserService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentReference _userRef;
  String _uid;
  UserService(String uid) {
    _userRef = _db.collection("users").doc(uid);
    _uid = uid;
  }

  Future<void> joinTeam(String teamNumber) async {
    await _userRef.update({
      'teamStatus': describeEnum(TeamStatus.PENDINGAPPROVAL),
      'teamNumber': teamNumber,
    });
  }

  Future<void> switchTeam(String newTeamNumber) async {
    await _userRef.update({
      'teamStatus': describeEnum(TeamStatus.PENDINGAPPROVAL),
      'teamNumber': newTeamNumber,
    });
  }

  Future<void> browseAsGuest() async {
    await _userRef.update({
      'teamStatus': describeEnum(TeamStatus.GUEST),
    });
  }
}
