import 'dart:convert';
import 'package:vaesen_beyond/data/datasources/local_storage_service.dart';
import 'package:vaesen_beyond/data/seed/castle_data.dart';
import 'package:vaesen_beyond/domain/models/castle.dart';
import 'package:vaesen_beyond/domain/models/character.dart';

class CharacterRepository {
  final LocalStorageService _storage;

  CharacterRepository({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService();

  Future<List<Character>> loadCharacters() async {
    final jsonStr = await _storage.getCharactersJson();
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((item) => Character.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAllCharacters(List<Character> characters) async {
    final listJson = characters.map((c) => c.toJson()).toList();
    final jsonStr = jsonEncode(listJson);
    await _storage.saveCharactersJson(jsonStr);
  }

  Future<void> saveCharacter(Character character) async {
    final list = await loadCharacters();
    final index = list.indexWhere((c) => c.id == character.id);
    if (index >= 0) {
      list[index] = character;
    } else {
      list.add(character);
    }
    await saveAllCharacters(list);
  }

  Future<void> deleteCharacter(String characterId) async {
    final list = await loadCharacters();
    list.removeWhere((c) => c.id == characterId);
    await saveAllCharacters(list);
  }

  Future<String?> getActiveCharacterId() async {
    return _storage.getActiveCharacterId();
  }

  Future<void> setActiveCharacterId(String id) async {
    await _storage.saveActiveCharacterId(id);
  }

  Future<void> clearActiveCharacterId() async {
    await _storage.clearActiveCharacterId();
  }

  Future<CastleState> loadCastleState() async {
    final jsonStr = await _storage.getCastleJson();
    if (jsonStr == null || jsonStr.trim().isEmpty) {
      final defaultCastle = CastleData.defaultCastle;
      await saveCastleState(defaultCastle);
      return defaultCastle;
    }
    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return CastleState.fromJson(decoded);
    } catch (_) {
      return CastleData.defaultCastle;
    }
  }

  Future<void> saveCastleState(CastleState castle) async {
    final jsonStr = jsonEncode(castle.toJson());
    await _storage.saveCastleJson(jsonStr);
  }

  String exportCharacterJson(Character character) {
    return const JsonEncoder.withIndent('  ').convert(character.toJson());
  }

  Character importCharacterFromJson(String jsonStr) {
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    return Character.fromJson(decoded);
  }

  Future<bool> hasAcceptedDisclaimer() async {
    return _storage.hasAcceptedDisclaimer();
  }

  Future<void> setDisclaimerAccepted(bool accepted) async {
    await _storage.setDisclaimerAccepted(accepted);
  }
}
