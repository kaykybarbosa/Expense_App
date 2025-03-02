import 'package:expense_app/app/routes/app_routes.dart';
import 'package:expense_app/ui/components/custom_container.dart';
import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/ui/pages/settings/controllers/settings_controller.dart';
import 'package:expense_app/ui/pages/settings/controllers/theme_controller.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsController _controller;
  late ThemeController _themeController;

  @override
  void initState() {
    super.initState();

    _controller = getIt<SettingsController>();
    _themeController = getIt<ThemeController>();

    _controller.getSettings();
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(centerTitle: true, title: const Text('SETTINGS')),
    body: Column(
      children: <Widget>[
        CustomContainer(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: Constants.defaultMargin,
          ),
          child: ListTile(
            leading: const Icon(MyIcons.moon),
            title: const Text('Dark mode'),
            trailing: CupertinoSwitch(
              value: _controller.settings.isDark,
              onChanged:
                  (value) => {
                    _controller.setSettings(_controller.settings.copyWith(isDark: value)),
                    _themeController.getThemeMode(),
                  },
            ),
          ),
        ),
        CustomContainer(
          child: ListTile(
            title: const Text('Help'),
            leading: const Icon(MyIcons.help),
            onTap: () => GoRouter.of(context).push(AppRoutes.help),
          ),
        ),
      ],
    ),
  );
}
