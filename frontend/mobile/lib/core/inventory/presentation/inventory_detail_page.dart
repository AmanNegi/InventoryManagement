import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/colors.dart";
import "package:inv_mgmt_client/core/bill/presentation/dialogs/confirm_dialog.dart";
import "package:inv_mgmt_client/core/inventory/application/inventory.dart";
import "package:inv_mgmt_client/core/inventory/presentation/add_inventory_page.dart";
import "package:inv_mgmt_client/core/inventory/presentation/edit_inventory_page.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/models/inventory_item.dart";
import "package:inv_mgmt_client/widgets/cached_image_view.dart";
import "package:inv_mgmt_client/widgets/img_fullview.dart";

class InventoryDetailPage extends ConsumerStatefulWidget {
  final InventoryItem item;
  const InventoryDetailPage({super.key, required this.item});

  @override
  ConsumerState<InventoryDetailPage> createState() =>
      _InventoryDetailPageState();
}

class _InventoryDetailPageState extends ConsumerState<InventoryDetailPage> {
  late InventoryManager manager;

  @override
  void initState() {
    manager = InventoryManager(ref, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
          IconButton(
            onPressed: () async {
              var res = await showDialog(
                context: context,
                builder: (context) {
                  return const ConfirmDialog(
                    text: "Are you sure you want to delete this item?",
                  );
                },
              );

              if (res == null || res is! bool) return;

              if (res) {
                await manager.deleteItem(widget.item.id);
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              goToPage(
                context,
                EditInventoryItemPage(
                  item: widget.item,
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.item.images.isEmpty
                ? Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 0.3 * getHeight(context),
                  )
                : GestureDetector(
                    onTap: () {
                      goToPage(
                          context, ImgFullView(src: widget.item.images[0]));
                    },
                    child: CachedImageView(
                      widget.item.images[0],
                      width: double.infinity,
                      height: 0.3 * getHeight(context),
                      fit: BoxFit.cover,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getHeading("Description"),
                  Text(widget.item.description),
                  getHeading("Cost Price"),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: dangerColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "$rupee ${widget.item.costPrice} ${widget.item.type == "loose" ? "/kg" : "/unit"}",
                      style: const TextStyle(
                        color: onDangerColor,
                      ),
                    ),
                  ),
                  getHeading("Selling Price"),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "$rupee ${widget.item.sellingPrice} ${widget.item.type == "loose" ? "/kg" : "/unit"}",
                      style: const TextStyle(color: onDangerColor),
                    ),
                  ),
                  getHeading("Quantity"),
                  Text(
                      "${widget.item.quantity.toStringAsFixed(2)} ${widget.item.type == "loose" ? "kgs" : "units"}"),
                  if (widget.item.type == "loose")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeading("Price per gram"),
                        Text("$rupee ${widget.item.sellingPrice / 1000}"),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
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
