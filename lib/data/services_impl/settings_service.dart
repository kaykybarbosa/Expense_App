// ignore_for_file: non_constant_identifier_names

import 'package:expense_app/domain/contracts/services/settings_service.dart';
import 'package:expense_app/domain/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService implements ISettingsService {
  SettingsService({required SharedPreferences sharedPrefs}) : _prefs = sharedPrefs;

  final KEY = 'SETTINGS_KEY';
  final SharedPreferences _prefs;

  @override
  Future<void> setSettings(SettingsModel settings) async =>
      await _prefs.setString(KEY, settings.toJson());

  @override
  SettingsModel get settings {
    var settings = _prefs.getString(KEY);

    if (settings != null) {
      return SettingsModel.fromJson(settings);
    }
    return SettingsModel();
  }
}
