import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustang_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SignInMethod {
  EMAIL_PASSWORD,
  GOOGLE,
  FACEBOOK,
}

class AuthService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection;

  AuthService() {
    usersCollection = _db.collection("users");
  }

  User get currentUser => _auth.currentUser;

  Future<UserModel> getUser(String uid) async {
    if (uid == null || uid == "") {
      return null;
    }
    return UserModel.fromSnapshot(await usersCollection.doc(uid).get());
  }

  Stream<UserModel> streamUser(User user) {
    return usersCollection
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
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> createAccount(String firstName, String lastName, String email,
      String password, SignInMethod method) async {
    String uid = "";
    if (method == SignInMethod.EMAIL_PASSWORD) {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      uid = cred.user.uid;
    } else if (currentUser != null) {
      uid = currentUser.uid;
    } else {
      throw new Exception("Uid not found");
    }

    await usersCollection.doc(uid).set(UserModel(
          uid,
          email,
          firstName,
          lastName,
          UserType.MEMBER,
        ).toJson());
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
