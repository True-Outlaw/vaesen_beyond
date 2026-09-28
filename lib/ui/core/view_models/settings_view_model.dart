import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/datasources/local_storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  SettingsViewModel({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService();

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> initialize() async {
    final code = await _storage.getSavedLocaleCode();
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? newLocale) async {
    _locale = newLocale;
    notifyListeners();
    if (newLocale != null) {
      await _storage.saveLocaleCode(newLocale.languageCode);
    }
  }
}
