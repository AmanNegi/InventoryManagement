import 'package:flutter/material.dart';
import 'package:inv_mgmt_client/colors.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/inventory_detail_page.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/models/transaction_item.dart';
import 'package:inv_mgmt_client/widgets/cached_image_view.dart';

class TransactionItemWidget extends StatelessWidget {
  final InventoryItem item;
  final TransactionItemDetails transactionItem;
  const TransactionItemWidget({
    super.key,
    required this.item,
    required this.transactionItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.1 * getHeight(context),
      child: Row(
        children: [
          Container(
            width: 0.2 * getWidth(context),
            height: 0.2 * getWidth(context),
            child: item.images.isEmpty
                ? Image.asset(
                    "assets/logo.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : CachedImageView(
                    item.images[0],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "Quantity: ${transactionItem.quantity}",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "Price: ${transactionItem.price}",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
