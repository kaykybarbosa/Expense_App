import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPressed;
  final void Function(BuildContext)? onDeletePressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.defaultMargin, vertical: 5),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: <Widget>[
              SlidableAction(
                icon: MyIcons.settings,
                onPressed: onEditPressed,
                backgroundColor: MyColors.base300,
                foregroundColor: MyColors.base100,
                borderRadius: BorderRadius.circular(5),
              ),
              SlidableAction(
                icon: MyIcons.delete,
                onPressed: onDeletePressed,
                backgroundColor: MyColors.alert,
                foregroundColor: MyColors.base100,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.base300Shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Text(title),
              trailing: Text(trailing),
            ),
          ),
        ),
      );
}
