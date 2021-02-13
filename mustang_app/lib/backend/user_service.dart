import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getUser(FirebaseUser user) async {
    return User.fromSnapshot(
        await _db.collection('users').document(user.uid).get());
  }

  Stream<User> streamUser(FirebaseUser user) {
    return _db
        .collection('users')
        .document(user.uid)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  Future<void> login() async {}

  Future<void> logout() async {}
}
