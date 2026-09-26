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

  Future<void> clearActiveCharacterId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kActiveCharacterIdKey);
  }

  Future<void> saveCastleJson(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCastleStateKey, jsonStr);
  }

  Future<String?> getCastleJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCastleStateKey);
  }

  static const _kDisclaimerAcceptedKey = 'vaesen_disclaimer_accepted_v1';

  Future<bool> hasAcceptedDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDisclaimerAcceptedKey) ?? false;
  }

  Future<void> setDisclaimerAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDisclaimerAcceptedKey, accepted);
  }

  static const _kBestiaryEnabledKey = 'vaesen_bestiary_enabled_v1';

  Future<bool> isBestiaryEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBestiaryEnabledKey) ?? false;
  }

  Future<void> setBestiaryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBestiaryEnabledKey, enabled);
  }
}
