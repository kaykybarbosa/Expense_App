import 'package:expense_app/domain/contracts/services/settings_service.dart';
import 'package:expense_app/domain/models/settings_model.dart';
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required ISettingsService settingsService})
    : _service = settingsService;

  final ISettingsService _service;
  SettingsModel _settings = SettingsModel();

  SettingsModel get settings => _settings;

  void getSettings() {
    _settings = _service.settings;

    notifyListeners();
  }

  Future<void> setSettings(SettingsModel settings) async => {
    await _service.setSettings(settings),
    getSettings(),
  };
}
