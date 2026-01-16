import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PrefsJsonStore {
  final SharedPreferences _prefs;
  PrefsJsonStore(this._prefs);

  String? readString(String key) => _prefs.getString(key);

  Future<void> writeString(String key, String value) => _prefs.setString(key, value);

  List<dynamic> readJsonList(String key) {
    final raw = readString(key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is List) return decoded;
    return const [];
  }

  Future<void> writeJsonList(String key, List<dynamic> value) =>
      writeString(key, jsonEncode(value));
}
