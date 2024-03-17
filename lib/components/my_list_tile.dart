import 'package:expense_app/helper/helper_functions.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.expense,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final Expense expense;
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
              boxShadow: [
                BoxShadow(
                  color: MyColors.base300.withOpacity(.2),
                  blurRadius: 5,
                )
              ],
            ),
            child: ListTile(
              title: Text(expense.name),
              subtitle: Text(
                formatDate(expense.date),
                style: const TextStyle(color: MyColors.base300, fontSize: 13),
              ),
              trailing: Text(
                formatAmount(expense.amount),
                style: const TextStyle(fontSize: Constants.defaultFontSize),
              ),
            ),
          ),
        ),
      );
}
