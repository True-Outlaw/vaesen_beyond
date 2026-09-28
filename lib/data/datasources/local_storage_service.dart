import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';

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

  // ── Custom Homebrew Talents ──────────────────────────────────────────────
  static const _kCustomTalentsKey = 'vaesen_custom_talents_json_v1';

  Future<String?> getCustomTalentsJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCustomTalentsKey);
  }

  Future<void> saveCustomTalentsJson(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCustomTalentsKey, jsonStr);
  }

  Future<List<Talent>> loadCustomTalents() async {
    final jsonStr = await getCustomTalentsJson();
    if (jsonStr == null || jsonStr.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((t) => Talent.fromJson(t as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomTalents(List<Talent> talents) async {
    final listJson = talents.map((t) => t.toJson()).toList();
    await saveCustomTalentsJson(jsonEncode(listJson));
  }

  // ── Bestiary Fog-of-War & Progressive Reveals ────────────────────────────
  static const _kBestiaryModeKey = 'vaesen_bestiary_mode_v1';
  static const _kRevealedSectionsKey = 'vaesen_bestiary_revealed_sections_v1';

  Future<String> getBestiaryMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_kBestiaryModeKey);
    if (mode != null) return mode;
    final enabled = await isBestiaryEnabled();
    return enabled ? 'gamemaster' : 'locked';
  }

  Future<void> setBestiaryMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBestiaryModeKey, mode);
    if (mode == 'gamemaster') {
      await setBestiaryEnabled(true);
    } else if (mode == 'locked') {
      await setBestiaryEnabled(false);
    }
  }

  Future<String?> getRevealedSectionsJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRevealedSectionsKey);
  }

  Future<void> saveRevealedSectionsJson(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRevealedSectionsKey, jsonStr);
  }
}
