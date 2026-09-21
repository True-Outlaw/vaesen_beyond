import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kCharactersKey = 'vaesen_characters_json';
  static const _kActiveCharacterIdKey = 'vaesen_active_character_id';
  static const _kCastleStateKey = 'vaesen_castle_state_json';

  Future<void> saveCharactersJson(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCharactersKey, jsonStr);
  }

  Future<String?> getCharactersJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCharactersKey);
  }

  Future<void> saveActiveCharacterId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kActiveCharacterIdKey, id);
  }

  Future<String?> getActiveCharacterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kActiveCharacterIdKey);
  }

  Future<void> saveCastleJson(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCastleStateKey, jsonStr);
  }

  Future<String?> getCastleJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCastleStateKey);
  }
}
