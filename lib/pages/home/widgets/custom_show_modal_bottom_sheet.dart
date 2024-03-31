import 'package:expense_app/components/custom_text_field.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:flutter/material.dart';

enum ModalButtomSheetType { create, edit }

void customShowModalButtomSheet(
  BuildContext context, {
  required void Function()? onPressed,
  required TextEditingController nameController,
  required TextEditingController amountController,
  ModalButtomSheetType type = ModalButtomSheetType.create,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _Title(type),
                  ),
                  CustomTextField(
                    label: 'Name',
                    isRequiredFocus: type == ModalButtomSheetType.create,
                    controller: nameController,
                  ),
                  CustomTextField(
                    label: 'Amount',
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 30),
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
  const _Title(this.type);

  final ModalButtomSheetType type;

  @override
  Widget build(BuildContext context) => Text(
        type == ModalButtomSheetType.create ? 'New Expense' : 'Edit Expense',
        style: const TextStyle(fontSize: Constants.largeFontSize),
      );
}
