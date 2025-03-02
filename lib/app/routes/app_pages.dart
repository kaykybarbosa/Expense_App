import 'package:expense_app/app/routes/app_routes.dart';
import 'package:expense_app/ui/pages/home/home_page.dart';
import 'package:expense_app/ui/pages/settings/settings_page.dart';
import 'package:expense_app/ui/pages/settings/sub_pages/app_info_page.dart';
import 'package:expense_app/ui/pages/settings/sub_pages/help_page.dart';
import 'package:go_router/go_router.dart';

class AppPages {
  static final GoRouter pages = GoRouter(
    initialLocation: AppRoutes.home,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) {
          return const SettingsPage();
        },
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) {
          return const HelpPage();
        },
      ),
      GoRoute(
        path: AppRoutes.appInfo,
        builder: (context, state) {
          return const AppInfoPage();
        },
      ),
    ],
  );
}
