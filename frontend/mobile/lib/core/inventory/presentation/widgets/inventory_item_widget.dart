import 'package:flutter/material.dart';
import 'package:inv_mgmt_client/colors.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/inventory_detail_page.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/widgets/cached_image_view.dart';

class GridItem extends StatelessWidget {
  final InventoryItem item;
  final Function? onClick;
  const GridItem({super.key, required this.item, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (onClick != null) {
                onClick!();
                return;
              }
              goToPage(context, InventoryDetailPage(item: item));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: cardColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: SizedBox(
                      height: 0.1 * getHeight(context),
                      child: item.images.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.45),
                              ),
                            )
                          : CachedImageView(
                              item.images[0],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text("Qty: ${item.quantity}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.025 * getWidth(context),
          right: 0.025 * getWidth(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              color: semiDarkColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              '₹ ${item.sellingPrice * 1.0}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
