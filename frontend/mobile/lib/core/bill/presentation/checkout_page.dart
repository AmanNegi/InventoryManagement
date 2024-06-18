import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/core/bill/application/bill.dart";
import "package:inv_mgmt_client/core/bill/presentation/dialogs/change_dialog.dart";
import "package:inv_mgmt_client/data/billing_state.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class CheckoutPage extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<BillingState> billingNotifier;
  const CheckoutPage({
    super.key,
    required this.billingNotifier,
  });

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  TextEditingController discountController = TextEditingController();
  String paymentMode = "cash";
  double totalAmount = 0.0;
  @override
  Widget build(BuildContext context) {
    paymentMode = ref.watch(widget.billingNotifier).paymentMode;
    totalAmount = ref.watch(widget.billingNotifier).totalAmount;
    discountController.text =
        ref.watch(widget.billingNotifier).discount.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout Page"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                DropdownButtonFormField(
                  hint: const Text("Payment Mode"),
                  value: paymentMode,
                  items: ["Cash", "Online", "Takeaway"].map((e) {
                    return DropdownMenuItem(
                        value: e.toLowerCase(), child: Text(e));
                  }).toList(),
                  onChanged: (e) {
                    ref.read(widget.billingNotifier).paymentMode = e.toString();
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Discount",
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    ref.read(widget.billingNotifier).discount = double.parse(v);
                    discountController.selection = TextSelection.fromPosition(
                      TextPosition(offset: discountController.text.length),
                    );
                  },
                ),
                SizedBox(height: 0.2 * getHeight(context)),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _getBottomBar(context),
          ),
          Positioned(
            right: 15,
            bottom: 0.2 * getHeight(context),
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ChangeDialog(
                      totalAmount: ref.read(widget.billingNotifier).totalAmount,
                    );
                  },
                );
              },
              child: const Icon(Icons.calculate),
            ),
          ),
        ],
      ),
    );
  }

  Container _getBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Original Amount: "),
                    const Spacer(),
                    Text(
                      " ₹${ref.read(widget.billingNotifier).originalAmount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Discounted Amount: "),
                    const Spacer(),
                    Text(
                      "₹$totalAmount",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.065 * getHeight(context),
            child: ActionButton(
              text: "Checkout",
              onPressed: () async {
                if (paymentMode == 'cash') {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return ChangeDialog(
                        totalAmount:
                            ref.read(widget.billingNotifier).totalAmount,
                      );
                    },
                  );
                }

                BillManager manager = BillManager(ref, context);
                var res = await manager.createBill(
                  customerName: ref.read(widget.billingNotifier).customerName,
                  totalAmount: ref.read(widget.billingNotifier).totalAmount,
                  paymentMethod: ref.read(widget.billingNotifier).paymentMode,
                  items: ref.read(widget.billingNotifier).items,
                  discountAmount: ref.read(widget.billingNotifier).discount,
                );

                if (res == 1 && mounted) Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
