import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/colors.dart";
import "package:inv_mgmt_client/core/bill/application/bill.dart";
import "package:inv_mgmt_client/core/home/presentation/home_page.dart";
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
  TextEditingController cashController = TextEditingController();

  String paymentMode = "cash";
  double totalAmount = 0.0;
  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    paymentMode = ref.read(widget.billingNotifier).paymentMode;
    totalAmount = ref.read(widget.billingNotifier).totalAmount;

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
                Container(
                  height: 0.065 * getHeight(context),
                  child: Row(children: [
                    _getButtonBarItem("Cash", 0),
                    SizedBox(width: 10),
                    _getButtonBarItem("Online", 1),
                    SizedBox(width: 10),
                    _getButtonBarItem("Takeaway", 2),
                  ]),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Discount",
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    print("value changed: " + v);
                    if (v.isEmpty) return;
                    ref.read(widget.billingNotifier).discount = double.parse(v);
                    // discountController.selection = TextSelection.fromPosition(
                    //   TextPosition(offset: discountController.text.length),
                    // );
                  },
                ),
                SizedBox(height: 10),
                if (paymentMode == "cash")
                  CustomTextField(
                    label: "Received Amount",
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      // cashController.selection = TextSelection.fromPosition(
                      //   TextPosition(offset: cashController.text.length),
                      // );
                    },
                  ),
                SizedBox(height: 10),
                if (paymentMode == "cash")
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Return Amount: ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder(
                            valueListenable: cashController,
                            builder: (context, value, child) {
                              return Consumer(builder: (context, ref, _) {
                                double tt = ref
                                    .watch(widget.billingNotifier)
                                    .totalAmount;
                                return Text(
                                  "₹${getChange(tt)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                );
                              });
                            }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _getBottomBar(context),
          ),
        ],
      ),
    );
  }

  _getButtonBarItem(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(widget.billingNotifier).paymentMode = text.toLowerCase();
          selectedButtonIndex = index;
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: index == selectedButtonIndex
                  ? accentColor
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: index == selectedButtonIndex
                    ? accentColor
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getBottomBar(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      double discount = ref.watch(widget.billingNotifier).discount;
      double totalAmount = ref.watch(widget.billingNotifier).totalAmount;

      print(discount);
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
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Original Amount: "),
                      const Spacer(),
                      Text(
                        "₹ ${ref.read(widget.billingNotifier).originalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          decorationThickness: 2.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Discount: "),
                      const Spacer(),
                      Text(
                        "- ₹ ${discount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          decorationThickness: 2.0,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      const Text("Total Amount: "),
                      const Spacer(),
                      Text(
                        "₹ ${totalAmount.toStringAsFixed(2)}",
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
            SizedBox(height: 0.025 * getHeight(context)),
            SizedBox(
              height: 0.065 * getHeight(context),
              child: ActionButton(
                text: "Checkout",
                onPressed: () async {
                  BillManager manager = BillManager(ref, context);
                  var res = await manager.createBill(
                    customerName: ref.read(widget.billingNotifier).customerName,
                    totalAmount: ref.read(widget.billingNotifier).totalAmount,
                    paymentMethod: ref.read(widget.billingNotifier).paymentMode,
                    items: ref.read(widget.billingNotifier).items,
                    discountAmount: ref.read(widget.billingNotifier).discount,
                  );

                  if (res == 1) {
                    ref.read(widget.billingNotifier).clearBill();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  getChange(double totalAmount) {
    double cash = 0;
    if (cashController.text.isNotEmpty) {
      cash = double.parse(cashController.text);
    }

    if (cash <= 0) return 0.0;

    double change = cash - totalAmount;
    if (change < 0) return 0.0;
    return change.toStringAsFixed(2);
  }
}
