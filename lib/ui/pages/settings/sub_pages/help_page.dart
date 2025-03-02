import 'package:expense_app/app/routes/app_routes.dart';
import 'package:expense_app/ui/components/custom_container.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> options = [
      {'leading': MyIcons.info, 'title': 'App info'},
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('HELP')),
      body: Column(
        children:
            options
                .map(
                  (e) => CustomContainer(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: Constants.defaultMargin,
                    ),
                    child: ListTile(
                      leading: Icon(e['leading']),
                      title: Text(e['title']),
                      onTap: () => GoRouter.of(context).push(AppRoutes.appInfo),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
