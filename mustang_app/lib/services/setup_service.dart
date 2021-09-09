import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SetupService {
  static Future<void> setup() async {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    // await FirebaseFirestore.instance.enablePersistence();
  }
}
