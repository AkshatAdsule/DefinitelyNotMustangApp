import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/user_statistic.dart';

enum UserType {
  MEMBER,
  OFFICER,
  MENTOR,
}

enum TeamStatus {
  GUEST,
  JOINED,
  PENDINGAPPROVAL,
  LONELY,
}

class UserModel {
  String uid, email, firstName, lastName, teamNumber;
  UserType userType;
  TeamStatus teamStatus;
  List<UserStatistic> stats;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.teamNumber,
    this.teamStatus,
    this.stats,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    data['uid'] = snapshot.id;
    return UserModel.fromJson(data);
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      userType: parseUserTypeFromString(data['userType']),
      teamNumber: data['teamNumber'],
      teamStatus: parseTeamStatusFromString(data['teamStatus']),
      stats: (data['stats'] != null)
          ? data['stats']
              .map<UserStatistic>((e) => UserStatistic.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userType': describeEnum(userType),
      'teamNumber': teamNumber,
      'teamStatus': describeEnum(teamStatus),
      'stats': stats,
    };
  }

  static UserType parseUserTypeFromString(String userType) {
    UserType ret;
    UserType.values.forEach((element) {
      if (describeEnum(element) == userType) {
        ret = element;
      }
    });
    return ret ?? UserType.MEMBER;
  }

  static TeamStatus parseTeamStatusFromString(String teamStatus) {
    TeamStatus ret;
    TeamStatus.values.forEach((element) {
      if (describeEnum(element).toUpperCase() == teamStatus) {
        ret = element;
      }
    });
    return ret ?? TeamStatus.GUEST;
  }
}
