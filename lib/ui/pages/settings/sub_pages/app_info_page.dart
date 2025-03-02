import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Expenses',
            style: TextStyle(
              fontSize: Constants.largeFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text('Version 1.0', style: TextStyle(color: MyColors.base300)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Icon(
              MyIcons.iconApp,
              color: MyColors.base100,
              // color: Theme.of(context).colorScheme.primary,
              size: 100,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MyIcons.copyright, size: 15, color: MyColors.base300),
              Text(' 2024 Kbuloso Ldta.', style: TextStyle(color: MyColors.base300)),
            ],
          ),
        ],
      ),
    ),
  );
}
