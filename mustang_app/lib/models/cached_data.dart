import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Represents data that is stored on device and has to be pushed to Firebase
class CachedData {
  /// The path of the data in Firebase Firestore
  final String dbpath;

  /// The data, JSON encoded
  final Map<String, dynamic> data;

  CachedData({
    @required this.dbpath,
    @required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'dbpath': dbpath,
      'data': jsonEncode(data),
    };
  }
}
