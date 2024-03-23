import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/domain/models/settings_model.dart';

abstract class ISettingsService {
  static ISettingsService get instance => getIt<ISettingsService>();

  SettingsModel get settings;

  Future<void> setSettings(SettingsModel settings);
}
