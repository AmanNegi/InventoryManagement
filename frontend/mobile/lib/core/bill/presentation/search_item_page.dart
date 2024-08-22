import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/colors.dart";
import 'package:inv_mgmt_client/core/inventory/presentation/widgets/inventory_item_widget.dart';
import "package:inv_mgmt_client/data/inventory_state.dart";
import "package:inv_mgmt_client/models/inventory_item.dart";
import "package:inv_mgmt_client/widgets/custom_text_field.dart";

class SearchItemPage extends StatefulWidget {
  const SearchItemPage({super.key});

  @override
  State<SearchItemPage> createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  List<InventoryItem> filteredItems = [];
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
        child: Column(
          children: [
            CustomTextField(
              hint: "Enter name",
              onChanged: (v) {
                query = v;
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) {
                var items = ref
                    .watch(inventoryProvider)
                    .allItems
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return InventoryItemWidget(
                      item: items[index],
                      manager: null,
                      onClick: () {
                        Navigator.pop(context, items[index]);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
