import 'package:expense_app/ui/components/custom_container.dart';
import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/domain/models/expense.dart';
import 'package:expense_app/data/extensions/date_time_extension.dart';
import 'package:expense_app/utils/helper_functions.dart';
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
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: Constants.defaultMargin,
        ),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: <Widget>[
              SlidableAction(
                icon: MyIcons.edit,
                onPressed: onEditPressed,
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
              SlidableAction(
                icon: MyIcons.delete,
                onPressed: onDeletePressed,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
            ],
          ),
          child: CustomContainer(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: ListTile(
              /// Name
              title: Text(expense.name),

              /// Date
              subtitle: Text(
                expense.date.formatDate,
                style: const TextStyle(
                  color: MyColors.base300,
                  fontSize: 13,
                ),
              ),

              /// Amount
              trailing: Text(
                formatAmount(expense.amount),
                style: TextStyle(
                  fontSize: Constants.defaultFontSize,
                  color: expense.type.isIncome ? MyColors.success : Theme.of(context).colorScheme.errorContainer,
                ),
              ),
            ),
          ),
        ),
      );
}
