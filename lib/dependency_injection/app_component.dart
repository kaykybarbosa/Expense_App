import 'package:expense_app/data/database/expense_database.dart';
import 'package:expense_app/domain/contracts/services/settings_service.dart';
import 'package:expense_app/objectbox.g.dart';
import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:expense_app/ui/pages/settings/controllers/settings_controller.dart';
import 'package:expense_app/ui/pages/settings/controllers/theme_controller.dart';
import 'package:expense_app/data/services_impl/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final Store store = await IExpenseDatabase.initialize;
  final SharedPreferences sharedPrefs = await ISettingsService.initialize;

  getIt.registerSingleton<Store>(store);
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);

  getIt.registerLazySingleton<IExpenseDatabase>(
    () => ExpenseDatabase(store: getIt<Store>()),
  );

  getIt.registerLazySingleton<ISettingsService>(
    () => SettingsService(sharedPrefs: getIt<SharedPreferences>()),
  );

  getIt.registerSingleton(HomeController());
  getIt.registerSingleton(SettingsController(settingsService: ISettingsService.instance));
  getIt.registerSingleton(ThemeController(settingsService: ISettingsService.instance));
}
