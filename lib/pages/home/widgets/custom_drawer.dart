import 'package:expense_app/app/routes/app_routes.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> options = [
      {
        'title': 'HOME',
        'icon': MyIcons.home,
        'onTap': () => GoRouter.of(context).pop(),
      },
      {
        'title': 'SETTINGS',
        'icon': MyIcons.settings,
        'onTap': () => GoRouter.of(context).push(AppRoutes.settings),
      },
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Image.asset(
              'assets/icon_android.png',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Column(
            children: options
                .map(
                  (e) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(e['icon']),
                    title: Text(e['title']),
                    onTap: e['onTap'],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
