import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _uid, _email, _firstName, _lastName;

  User(
    this._uid,
    this._email,
    this._firstName,
    this._lastName,
  );

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return User(
      snapshot.id,
      data['email'],
      data['firstName'],
      data['lastName'],
    );
  }

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
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
