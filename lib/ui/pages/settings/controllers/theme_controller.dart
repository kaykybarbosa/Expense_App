import 'package:expense_app/domain/contracts/services/settings_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({required ISettingsService settingsService}) : _service = settingsService;

  final ISettingsService _service;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void getThemeMode() {
    _themeMode = _service.settings.isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> updadeAppTheme(bool isDark) async => {
        await _service.setSettings(_service.settings.copyWith(isDark: isDark)),
        getThemeMode(),
      };
}
