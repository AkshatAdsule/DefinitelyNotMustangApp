import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _uid, _email, _firstName, _lastName;

  UserModel(
    this._uid,
    this._email,
    this._firstName,
    this._lastName,
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
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      data['uid'],
      data['email'],
      data['firstName'],
      data['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'firstName': _firstName,
      'lastName': _lastName,
    };
  }

  String get uid => _uid;
  String get email => _email;
  String get firstName => _firstName;
  String get lastName => _lastName;

  set uid(String uid) => _uid = uid;
  set email(String email) => _email = email;
  set firstName(String firstName) => _firstName = firstName;
  set lastName(String lastName) => _lastName = lastName;
}
