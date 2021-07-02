import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum UserType {
  MEMBER,
  OFFICER,
  MENTOR,
}

enum TeamStatus {
  GUEST,
  JOINED,
  PENDING_APPROVAL,
  LONELY,
}

class UserModel {
  String _uid, _email, _firstName, _lastName, _teamNumber;
  UserType _userType;
  TeamStatus _teamStatus;

  UserModel(
    this._uid,
    this._email,
    this._firstName,
    this._lastName,
    this._userType,
    this._teamNumber,
    this._teamStatus,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return UserModel(
      snapshot.id,
      data['email'],
      data['firstName'],
      data['lastName'],
      parseUserTypeFromString(data['userType']),
      data['teamNumber'],
      parseTeamStatusFromString(data['teamStatus']),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        data['uid'],
        data['email'],
        data['firstName'],
        data['lastName'],
        parseUserTypeFromString(data['userType']),
        data['teamNumber'],
        parseTeamStatusFromString(data['teamStatus']));
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'firstName': _firstName,
      'lastName': _lastName,
      'userType': describeEnum(_userType),
      'teamNumber': _teamNumber,
    };
  }

  String get uid => _uid;
  String get email => _email;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get teamNumber => _teamNumber;
  UserType get userType => _userType;
  TeamStatus get teamStatus => _teamStatus;

  set uid(String uid) => _uid = uid;
  set email(String email) => _email = email;
  set firstName(String firstName) => _firstName = firstName;
  set lastName(String lastName) => _lastName = lastName;
  set userType(UserType userType) => _userType = userType;
  set teamNumber(String teamNumber) => _teamNumber = teamNumber;
  set teamStatus(TeamStatus teamStatus) => _teamStatus = teamStatus;
}

UserType parseUserTypeFromString(String userType) {
  UserType.values.forEach((element) {
    if (describeEnum(element) == userType) {
      return element;
    }
  });
  return UserType.MEMBER;
}

TeamStatus parseTeamStatusFromString(String teamStatus) {
  TeamStatus.values.forEach((element) {
    if (describeEnum(element) == teamStatus) {
      return element;
    }
  });
  return TeamStatus.GUEST;
}
