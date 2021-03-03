import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<User> getUser(auth.User user) async {
    return User.fromSnapshot(
        await _db.collection('users').doc(user.uid).get());
  }

  Stream<User> streamUser(User user) {
    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  Future<void> login() async {}

  Future<void> logout() async {}
}
