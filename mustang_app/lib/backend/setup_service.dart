import 'package:firebase_core/firebase_core.dart';

class SetupService {
  static Future<void> setup() async {
    await Firebase.initializeApp();
  }
}
