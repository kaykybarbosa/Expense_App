import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/domain/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsService {
  static Future<SharedPreferences> get initialize async =>
      await SharedPreferences.getInstance();

  static ISettingsService get instance => getIt<ISettingsService>();

  SettingsModel get settings;

  Future<void> setSettings(SettingsModel settings);
}
