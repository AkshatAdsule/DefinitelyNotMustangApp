import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mustang_app/models/cached_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A simple wrapper over Firestore that implements basic offline caching.
class DataService {
  static DataService _instance;

  List<CachedData> _cache = [];

  static DataService getInstance() {
    if (_instance == null) {
      _instance = DataService();
    }
    return _instance;
  }

  /// Tries to upload the current cache to firebase. Throws an error if there is no internet connection.
  void tryUploadCache() async {
    try {
      // read the chache from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cache = prefs.getString('cache');
      if (cache != null || cache.length > 0) {
        // parse the cache
        (json.decode(cache) as List).forEach((i) {
          _cache.add(CachedData(
            dbpath: i["dbpath"],
            data: jsonDecode(
              i["data"],
            ),
          ));
        });
      }
      print("Internet restored; Trying upload cache");
      if (_cache.length > 0) {
        _cache.forEach((item) async {
          await FirebaseFirestore.instance
              .doc(item.dbpath)
              .set(item.data, SetOptions(merge: true));
          _cache.remove(item);
        });
        writeCacheToPrefs();
        return;
      }
    } catch (_) {
      throw Exception("No internet connection");
    }
  }

  /// Tries to upload the given document to the database. If there is no internet connection, it will be cached.
  void tryUploadDoc({String path, Map<String, dynamic> data}) async {
    bool isConnected =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    if (isConnected) {
      await FirebaseFirestore.instance
          .doc(path)
          .set(data, SetOptions(merge: true));
    } else {
      print("No internet connection, adding data to cache");
      _cache.add(
        CachedData(dbpath: path, data: data),
      );
      writeCacheToPrefs();
    }
  }

  /// Writes the contents of the cache to shared preferences.
  void writeCacheToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheString =
        _cache.map((e) => jsonEncode(e.toJson())).toList().toString();
    print(cacheString);
    prefs.setString("cache", cacheString);
  }
}
