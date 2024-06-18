import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/colors.dart";
import "package:inv_mgmt_client/core/bill/application/bill.dart";
import "package:inv_mgmt_client/core/bill/presentation/checkout_page.dart";
import "package:inv_mgmt_client/core/bill/presentation/dialogs/change_dialog.dart";
import "package:inv_mgmt_client/core/bill/presentation/dialogs/confirm_dialog.dart";
import "package:inv_mgmt_client/core/bill/presentation/search_item_page.dart";
import "package:inv_mgmt_client/core/bill/presentation/widgets/bill_item.dart";
import "package:inv_mgmt_client/data/billing_state.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/models/inventory_item.dart";
import "package:inv_mgmt_client/widgets/action_button.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class BillPage extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<BillingState> billingNotifier;
  const BillPage(this.billingNotifier, {super.key});

  @override
  ConsumerState<BillPage> createState() => _BillPageState();
}

class _BillPageState extends ConsumerState<BillPage> {
  List<BillingItem> _items = [];
  String customerName = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _items = ref.watch(widget.billingNotifier).items;
    customerName = ref.watch(widget.billingNotifier).customerName;
    controller.text = customerName;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kTextTabBarHeight - 10),
            _getHeading("Customer Details"),
            CustomTextField(
              hint: "Buyer Name (optional)",
              controller: controller,
              onChanged: (v) {
                ref.read(widget.billingNotifier).customerName = (v);
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
            ),
            GestureDetector(
              onTap: () async {
                var result = await goToPage(context, const SearchItemPage());
                if (result != null && result is InventoryItem) {
                  ref.read(widget.billingNotifier).addItem(
                        BillingItem(
                          item: result,
                          quantity: 1.0,
                        ),
                      );
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
                  child: Row(
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          var result =
                              await goToPage(context, const SearchItemPage());
                          if (result != null && result is InventoryItem) {
                            ref.read(widget.billingNotifier).addItem(
                                BillingItem(item: result, quantity: 1));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _items.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return BillItemWidget(
                        item: _items[index],
                        billingNotifier: widget.billingNotifier,
                      );
                    },
                  )
                : const Center(child: Text("No items added yet")),
            SizedBox(
              height: 0.05 * getHeight(context),
            ),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    text: "Checkout",
                    onPressed: () async {
                      if (_items.isEmpty) {
                        showToast("Add items to checkout");
                        return;
                      }

                      goToPage(
                        context,
                        CheckoutPage(
                          billingNotifier: widget.billingNotifier,
                        ),
                      );

                      // if (paymentMode == 'cash') {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return ChangeDialog(
                      //         totalAmount:
                      //             ref.read(widget.billingNotifier).totalAmount,
                      //       );
                      //     },
                      //   );
                      // }

                      // BillManager manager = BillManager(ref, context);
                      // await manager.createBill(
                      //   customerName:
                      //       ref.read(widget.billingNotifier).customerName,
                      //   totalAmount:
                      //       ref.read(widget.billingNotifier).totalAmount,
                      //   paymentMethod:
                      //       ref.read(widget.billingNotifier).paymentMode,
                      //   items: ref.read(widget.billingNotifier).items,
                      // );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: dangerColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      var res = await showDialog(
                          context: context,
                          builder: (context) {
                            return const ConfirmDialog(
                                text:
                                    "Are you sure you want to clear the bill?");
                          });
                      if (res is bool) {
                        if (res) {
                          ref.read(widget.billingNotifier).clearBill();
                        }
                      }
                      print(res);
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: dangerColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
