import 'package:expense_app/helper/helper_functions.dart';
import 'package:expense_app/pages/home/home_page.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.future});

  final Future<double?>? future;

  @override
  Widget build(BuildContext context) {
    var homeState = context.findAncestorStateOfType<HomePageState>();

    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => homeState?.drawerController.showDrawer(),
        child: const Icon(
          size: 26,
          MyIcons.menu,
        ),
      ),
      title: FutureBuilder(
        future: future,
        builder: (_, snapshot) => snapshot.connectionState == ConnectionState.done
            ? Text(
                '\$${snapshot.data!.toStringAsFixed(2)}',
                style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(fontWeight: FontWeight.w500),
              )
            : const Text('Loading...'),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: null,
          icon: Text(
            getCurrentMonth(),
            style: const TextStyle(
              fontSize: Constants.defaultFontSize + 4,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
