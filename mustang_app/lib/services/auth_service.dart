import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustang_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User get currentUser => _auth.currentUser;

  Future<UserModel> getUser(String uid) async {
    if (uid == null || uid == "") {
      return null;
    }
    return UserModel.fromSnapshot(await _db.collection('users').doc(uid).get());
  }

  Stream<UserModel> streamUser(User user) {
    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snap) => UserModel.fromSnapshot(snap));
  }

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
