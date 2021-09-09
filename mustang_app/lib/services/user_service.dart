import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/services/auth_service.dart';

class UserService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentReference _userRef;
  String _uid;
  UserService(this._uid) {
    _userRef = _db.collection("users").doc(_uid);
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

  Future<UserModel> promoteUser({UserType type}) async {
    UserModel user = await AuthService.getUser(this._uid);

    switch (user.userType) {
      case UserType.MEMBER:
        user.userType = UserType.OFFICER;
        break;
      case UserType.OFFICER:
        user.userType = UserType.MENTOR;
        break;
      case UserType.MENTOR:
        break;
    }
    if (type != null) {
      user.userType = type;
    }
    await _userRef.set(user.toJson());
    return user;
  }

  Future<UserModel> demoteUser({UserType type}) async {
    UserModel user = await AuthService.getUser(this._uid);
    switch (user.userType) {
      case UserType.MEMBER:
        break;
      case UserType.OFFICER:
        user.userType = UserType.MEMBER;
        break;
      case UserType.MENTOR:
        user.userType = UserType.OFFICER;
        break;
    }
    if (type != null) {
      user.userType = type;
    }
    await _userRef.set(user.toJson());
    return user;
  }
}
