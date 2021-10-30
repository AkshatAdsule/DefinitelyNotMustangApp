import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStatistic {
  String name;
  double total;

  UserStatistic({@required this.name, @required this.total});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
    };
  }

  factory UserStatistic.fromJson(Map<String, dynamic> json) {
    return UserStatistic(
      name: json['name'],
      total: json['total'].toDouble(),
    );
  }

  factory UserStatistic.fromSnapshot(DocumentSnapshot snap) {
    return UserStatistic.fromJson(snap.data());
  }
}
