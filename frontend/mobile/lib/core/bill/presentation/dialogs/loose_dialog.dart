import "package:flutter/material.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class LooseDialog extends StatefulWidget {
  final double quantity;
  final double pricePerGram;
  const LooseDialog(
      {super.key, required this.quantity, required this.pricePerGram});

  @override
  State<LooseDialog> createState() => _LooseDialogState();
}

class _LooseDialogState extends State<LooseDialog> {
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    quantityController.text = widget.quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0.025 * getHeight(context)),
              Text("Update Quantity (${widget.pricePerGram}/g)",
                  style: const TextStyle(fontSize: 18)),
              SizedBox(height: 0.01 * getHeight(context)),
              CustomTextField(
                label: "Quantity (kg)",
                keyboardType: TextInputType.number,
                controller: quantityController,
                onChanged: (v) {
                  quantityController.selection = TextSelection.fromPosition(
                    TextPosition(offset: quantityController.text.length),
                  );
                },
              ),
              SizedBox(height: 0.01 * getHeight(context)),
              ActionButton(
                text: "Cancel",
                onPressed: () => Navigator.pop(context, null),
              ),
              SizedBox(height: 0.01 * getHeight(context)),
              ActionButton(
                text: "Update",
                onPressed: () => Navigator.pop(
                    context, double.parse(quantityController.text)),
                isFilled: false,
              ),
              SizedBox(height: 0.025 * getHeight(context)),
            ]),
      ),
    );
  }
}
