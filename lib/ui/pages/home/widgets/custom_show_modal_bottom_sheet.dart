import 'package:expense_app/data/extensions/date_time_extension.dart';
import 'package:expense_app/data/extensions/string_extension.dart';
import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/ui/components/custom_text_field.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/input_formatter.dart';
import 'package:expense_app/utils/my_icons.dart';
import 'package:flutter/material.dart';

enum ModalButtomSheetType { create, edit }

extension ModalButtomSheetTypeZ on ModalButtomSheetType {
  bool get isCreate => this == ModalButtomSheetType.create;
  bool get isEdit => this == ModalButtomSheetType.edit;
}

void customShowModalButtomSheet(
  BuildContext context, {
  required void Function()? onPressed,
  required TextEditingController nameController,
  required TextEditingController amountController,
  required TextEditingController dateController,
  ModalButtomSheetType buttomSheetType = ModalButtomSheetType.create,
  ExpenseType? expenseType,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    builder:
        (context) => Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: Constants.defaultMargin,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _Title(
                  buttomSheetType: buttomSheetType,
                  expenseType: expenseType ?? ExpenseType.expense,
                ),
              ),

              /// Form
              Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// -- Name
                  CustomTextField(
                    hintText: 'Name',
                    label: 'Name*',
                    isRequiredFocus: buttomSheetType.isCreate,
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                  ),

                  /// -- Amount
                  CustomTextField(
                    label: 'Amount*',
                    hintText: '0,00',
                    controller: amountController,
                    prefix: Text(
                      'R\$ ',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatter: InputFormatter.money,
                  ),

                  /// -- Date
                  CustomTextField(
                    label: 'Date',
                    hintText: 'dd/mm/yyyy',
                    controller: dateController,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final dateSelected = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: dateController.text.tryParse ?? DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );

                        final date = dateSelected?.formatDate;
                        if (date != null) {
                          dateController.text = date;
                        }
                      },
                      icon: Icon(MyIcons.calendar),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatter: InputFormatter.date,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Save
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(onPressed: onPressed, child: const Text('SAVE')),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
  );
}

class _Title extends StatelessWidget {
  const _Title({required this.buttomSheetType, required this.expenseType});

  final ModalButtomSheetType buttomSheetType;
  final ExpenseType expenseType;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: Constants.largeFontSize);

    return buttomSheetType.isCreate
        ? Text(expenseType.isIncome ? 'New Income' : 'New Expense', style: style)
        : Text(expenseType.isIncome ? 'Edit Income' : 'Edit Expense', style: style);
  }
}
