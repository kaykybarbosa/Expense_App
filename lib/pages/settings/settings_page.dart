import 'package:expense_app/components/custom_container.dart';
import 'package:expense_app/dependency_injection/app_component.dart';
import 'package:expense_app/pages/settings/settings_controller.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsController _controller;

  @override
  void initState() {
    super.initState();

    _controller = getIt<SettingsController>();
    _controller.getSettings();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('SETTINGS'),
        ),
        body: CustomContainer(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: Constants.defaultMargin,
          ),
          child: ListTile(
            title: const Text('Dark mode'),
            trailing: CupertinoSwitch(
              value: _controller.settings.isDark,
              onChanged: (value) => _controller.setSettings(
                _controller.settings.copyWith(isDark: value),
              ),
            ),
          ),
        ),
      );
}
