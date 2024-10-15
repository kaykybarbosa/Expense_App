// ignore_for_file: use_build_context_synchronously

import 'package:expense_app/components/custom_text_field.dart';
import 'package:expense_app/domain/enums/expense_type.dart';
import 'package:expense_app/utils/constants.dart';
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
  ModalButtomSheetType buttomSheetType = ModalButtomSheetType.create,
  ExpenseType? expenseType,
}) async =>
    Future.delayed(
      Duration.zero,
      () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          builder: (context) {
            return Container(
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

                  /// Name
                  CustomTextField(
                    label: 'Name',
                    isRequiredFocus: buttomSheetType.isCreate,
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                  ),

                  /// Amout
                  CustomTextField(
                    label: 'Amount',
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                  ),

                  const SizedBox(height: 30),

                  /// Save
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Text('SAVE'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );

class _Title extends StatelessWidget {
  const _Title({required this.buttomSheetType, required this.expenseType});

  final ModalButtomSheetType buttomSheetType;
  final ExpenseType expenseType;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: Constants.largeFontSize);

    return buttomSheetType.isCreate
        ? Text(
            expenseType.isIncome ? 'New Income' : 'New Expense',
            style: style,
          )
        : Text(
            expenseType.isIncome ? 'Edit Income' : 'Edit Expense',
            style: style,
          );
  }
}
