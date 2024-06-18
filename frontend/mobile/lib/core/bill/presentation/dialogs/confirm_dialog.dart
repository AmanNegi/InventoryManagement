import "package:flutter/material.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";

class ConfirmDialog extends StatefulWidget {
  final String text;
  const ConfirmDialog({super.key, required this.text});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
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
              Text(widget.text, style: const TextStyle(fontSize: 18)),
              SizedBox(height: 0.01 * getHeight(context)),
              ActionButton(
                text: "Cancel",
                onPressed: () => Navigator.pop(context, false),
              ),
              SizedBox(height: 0.01 * getHeight(context)),
              ActionButton(
                text: "Continue",
                onPressed: () => Navigator.pop(context, true),
                isFilled: false,
              ),
              SizedBox(height: 0.025 * getHeight(context)),
            ]),
      ),
    );
  }
}
