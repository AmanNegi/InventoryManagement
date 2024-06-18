import "package:flutter/material.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class ChangeDialog extends StatefulWidget {
  final double totalAmount;
  const ChangeDialog({super.key, required this.totalAmount});

  @override
  State<ChangeDialog> createState() => _ChangeDialogState();
}

class _ChangeDialogState extends State<ChangeDialog> {
  double returnAmount = 0;

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
            const Text("Change Calculator", style: TextStyle(fontSize: 18)),
            SizedBox(height: 0.02 * getHeight(context)),
            CustomTextField(
              hint: "Enter Amount Received",
              keyboardType: TextInputType.number,
              onChanged: (v) {
                if (v.isEmpty) return;
                print(widget.totalAmount);
                print(v);
                print(double.parse(v));
                returnAmount = double.parse(v) - widget.totalAmount;
                if (returnAmount < 0) {
                  returnAmount = 0;
                }
                setState(() {});
              },
            ),
            SizedBox(height: 0.02 * getHeight(context)),
            ActionButton(
              text: "Return Amount: $returnAmount",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 0.025 * getHeight(context)),
          ],
        ),
      ),
    );
  }
}
