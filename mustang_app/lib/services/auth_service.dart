import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustang_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      return await _auth.signInWithPopup(authProvider);
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    }

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
          uid: uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          userType: UserType.MEMBER,
          teamNumber: "",
          teamStatus: TeamStatus.LONELY,
        ).toJson());
  }

  Future<void> sendVerificationEmail() async {
    if (currentUser != null) {
      PackageInfo info = await PackageInfo.fromPlatform();

      await currentUser.sendEmailVerification(
        ActionCodeSettings(
          url:
              'https://mustangapp.page.link/handleverification?email=${currentUser.email}',
          dynamicLinkDomain: "mustangapp.page.link",
          handleCodeInApp: true,
          androidPackageName: info.packageName,
          iOSBundleId: info.packageName,
          androidInstallApp: true,
        ),
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    PackageInfo info = await PackageInfo.fromPlatform();

    await _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url:
            'https://mustangapp.page.link/handleverification?email=${currentUser.email}',
        dynamicLinkDomain: "mustangapp.page.link",
        handleCodeInApp: true,
        androidPackageName: info.packageName,
        iOSBundleId: info.packageName,
        androidInstallApp: true,
      ),
    );
  }

  Future<void> resetPassword(String oobCode, String newPassword) async {
    await _auth.confirmPasswordReset(code: oobCode, newPassword: newPassword);
  }

  Future<ActionCodeInfo> getActionCodeOperation(String oobCode) async {
    return await _auth.checkActionCode(oobCode);
  }

  Future<void> handleOobCode(String oobCode) async {
    await _auth.applyActionCode(oobCode);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
