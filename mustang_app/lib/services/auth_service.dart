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
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _usersCollection = _db.collection("users");

  static Stream<User> onAuthStateChanged() => _auth.authStateChanges();
  static Stream<User> onUserChanged() => _auth.userChanges();
  static Stream<User> onIdTokenChanged() => _auth.idTokenChanges();

  static User get currentUser => _auth.currentUser;

  static Future<UserModel> getUser(String uid) async {
    if (uid == null || uid == "") {
      return null;
    }
    return UserModel.fromSnapshot(await _usersCollection.doc(uid).get());
  }

  static Stream<UserModel> streamUser(User user) {
    // return _usersCollection
    //     .doc(user.uid)
    //     .snapshots()
    //     .map((snap) => UserModel.fromSnapshot(snap));
  }

  static Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> loginWithGoogle() async {
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

  static Future<void> createAccount(String firstName, String lastName,
      String email, String password, SignInMethod method) async {
    String uid = "";
    if (method == SignInMethod.EMAIL_PASSWORD) {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await currentUser.updateDisplayName("$firstName $lastName");
      await currentUser.updateEmail(email);
      uid = cred.user.uid;
    } else if (currentUser != null) {
      uid = currentUser.uid;
    } else {
      throw new Exception("Uid not found");
    }

    await _usersCollection.doc(uid).set(UserModel(
          uid: uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          userType: UserType.MEMBER,
          teamNumber: "",
          teamStatus: TeamStatus.LONELY,
        ).toJson());
  }

  static Future<void> sendVerificationEmail() async {
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

  static Future<void> sendPasswordResetEmail(String email) async {
    PackageInfo info = await PackageInfo.fromPlatform();

    await _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://mustangapp.page.link/handleverification?email=${email}',
        dynamicLinkDomain: "mustangapp.page.link",
        handleCodeInApp: true,
        androidPackageName: info.packageName,
        iOSBundleId: info.packageName,
        androidInstallApp: true,
      ),
    );
  }

  static Future<void> resetPassword(String oobCode, String newPassword) async {
    await _auth.confirmPasswordReset(code: oobCode, newPassword: newPassword);
  }

  static Future<ActionCodeInfo> getActionCodeOperation(String oobCode) async {
    return await _auth.checkActionCode(oobCode);
  }

  static Future<void> handleOobCode(String oobCode) async {
    await _auth.applyActionCode(oobCode);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<void> deleteAccount() async {
    if (currentUser != null) {
      await _db.collection("users").doc(currentUser.uid).delete();
      await _auth.currentUser.delete();
    }
  }
}
