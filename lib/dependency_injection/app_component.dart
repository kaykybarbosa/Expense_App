import 'package:expense_app/domain/contracts/services/settings_service.dart';
import 'package:expense_app/pages/home/home_controller.dart';
import 'package:expense_app/pages/settings/controllers/settings_controller.dart';
import 'package:expense_app/pages/settings/controllers/theme_controller.dart';
import 'package:expense_app/services_impl/settings_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<ISettingsService>(() => SettingsService());

  getIt.registerSingleton(HomeController());
  getIt.registerSingleton(SettingsController(settingsService: ISettingsService.instance));
  getIt.registerSingleton(ThemeController(settingsService: ISettingsService.instance));
}
