// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';

// class DataProvider {
//   static Future<TaskSnapshot> exportDB() async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final File file = File('${directory.path}/_db.json');

//     Map<String, Map<String, dynamic>> data = {};
//     final FirebaseFirestore _db = FirebaseFirestore.instance;
//     TaskSnapshot ref = FirebaseStorage.instance.ref().child('_db.json');
//     QuerySnapshot teams = await _db.collection('teams').getdocs();
//     teams.docs.forEach((doc) async {
//       data[doc.id] = {};
//       data[doc.id]['Match Scouting'] =
//           new Map<String, Map<String, dynamic>>();
//       data[doc.id].addAll(doc.data());
//       QuerySnapshot matches =
//           await doc.reference.collection('Match Scouting').get();
//       matches.docs.forEach((match) {
//         data[doc.id]['Match Scouting'][match.id] = match.data;
//       });
//     });

//     File updated = await file.writeAsString(jsonEncode(data));
//     return ref.put(updated).onComplete;
//   }

//   // static Future<void> importDB() async { }
// }
