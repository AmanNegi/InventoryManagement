import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/colors.dart";
import "package:inv_mgmt_client/core/bill/presentation/dialogs/loose_dialog.dart";
import "package:inv_mgmt_client/data/billing_state.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/cached_image_view.dart";

class BillItemWidget extends ConsumerWidget {
  final BillingItem item;
  final ChangeNotifierProvider<BillingState> billingNotifier;
  const BillItemWidget({
    super.key,
    required this.item,
    required this.billingNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 0.15 * getHeight(context),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onDoubleTap: () async {
                // show a dialog that helps user with loose items
                if (item.item.type == "loose") {
                  double pricePerGram = item.item.sellingPrice / 1000;
                  var res = await showDialog(
                    context: context,
                    builder: (context) => LooseDialog(
                      quantity: item.quantity,
                      pricePerGram: pricePerGram,
                    ),
                  );

                  if (res != null && res is double) {
                    ref.read(billingNotifier).updateItem(
                          BillingItem(
                            item: item.item,
                            quantity: res,
                          ),
                        );
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: cardColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item.item.images.isNotEmpty
                        ? SizedBox(
                            height: 0.2 * getWidth(context),
                            width: 0.2 * getWidth(context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedImageView(
                                item.item.images[0],
                              ),
                            ),
                          )
                        : Container(
                            height: 0.2 * getWidth(context),
                            width: 0.2 * getWidth(context),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                    SizedBox(width: 0.025 * getHeight(context)),
                    Expanded(
                      child: SizedBox(
                        height: 0.2 * getWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.item.title,
                                ),
                              ],
                            ),
                            Builder(builder: (context) {
                              double finalPrice = 0.0;
                              if (item.item.type == "loose") {
                                double pricePerGram =
                                    item.item.sellingPrice / 1000;
                                finalPrice =
                                    pricePerGram * item.quantity * 1000;
                              } else {
                                finalPrice =
                                    item.item.sellingPrice * item.quantity;
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "₹ ${item.item.sellingPrice} | ${item.quantity} ${isLooseItem(item) ? "kg" : "pcs"}"),
                                  Text(
                                    "₹ ${finalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0.25 * getWidth(context),
            child: CircleAvatar(
              backgroundColor: Colors.amber[900],
              maxRadius: 18,
              child: IconButton(
                icon: const Icon(
                  Icons.remove,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (item.quantity == 1) {
                    ref.read(billingNotifier).removeItem(item);
                    return;
                  }
                  ref.read(billingNotifier).updateItem(
                        BillingItem(
                          item: item.item,
                          quantity: item.quantity - 1,
                        ),
                      );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0.125 * getWidth(context),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              maxRadius: 18,
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () {
                  ref.read(billingNotifier).updateItem(
                        BillingItem(
                          item: item.item,
                          quantity: item.quantity + 1,
                        ),
                      );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              maxRadius: 18,
              backgroundColor: dangerColor,
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: onDangerColor,
                  size: 18,
                ),
                onPressed: () {
                  ref.read(billingNotifier).removeItem(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
