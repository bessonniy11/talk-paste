import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/app/models/app_settings.dart'; // Corrected import path

class SettingsService with ChangeNotifier {
  static const String _settingsKey = 'app_settings';

  AppSettings _settings;

  AppSettings get settings => _settings;

  SettingsService({AppSettings? initialSettings})
      : _settings = initialSettings ?? AppSettings();

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsString = prefs.getString(_settingsKey);

    if (settingsString != null) {
      try {
        _settings = AppSettings.fromJson(json.decode(settingsString));
      } catch (e) {
        // Fallback to default settings if parsing fails
        _settings = AppSettings();
        debugPrint('Error loading settings: $e. Reverting to default.');
      }
    } else {
      _settings = AppSettings();
    }
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String settingsString = json.encode(_settings.toJson());
    await prefs.setString(_settingsKey, settingsString);
  }

  Future<void> updateSettings({
    String? hotkeyCombination,
    bool? alwaysOnTop,
    bool? hideWidget,
    bool? runAtStartup,
  }) async {
    _settings = _settings.copyWith(
      hotkeyCombination: hotkeyCombination,
      alwaysOnTop: alwaysOnTop,
      hideWidget: hideWidget,
      runAtStartup: runAtStartup,
    );
    await saveSettings();
    notifyListeners();
  }
}
