import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class DataProvider {
  static Future<StorageTaskSnapshot> exportDB() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/_db.json');

    Map<String, Map<String, dynamic>> data = {};
    final Firestore _db = Firestore.instance;
    StorageReference ref = FirebaseStorage.instance.ref().child('_db.json');
    QuerySnapshot teams = await _db.collection('teams').getDocuments();
    teams.documents.forEach((doc) async {
      data[doc.documentID] = {};
      data[doc.documentID]['Match Scouting'] =
          new Map<String, Map<String, dynamic>>();
      data[doc.documentID].addAll(doc.data);
      QuerySnapshot matches =
          await doc.reference.collection('Match Scouting').getDocuments();
      matches.documents.forEach((match) {
        data[doc.documentID]['Match Scouting'][match.documentID] = match.data;
      });
    });

    File updated = await file.writeAsString(jsonEncode(data));
    return ref.putFile(updated).onComplete;
  }

  // static Future<void> importDB() async { }
}
