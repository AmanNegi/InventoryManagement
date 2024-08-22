import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/colors.dart';
import 'package:inv_mgmt_client/core/inventory/application/inventory.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/add_inventory_page.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/widgets/inventory_item_widget.dart';
import 'package:inv_mgmt_client/data/inventory_state.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/widgets/loading_widget.dart';

class InventoryPage extends ConsumerStatefulWidget {
  final InventoryManager manager;
  const InventoryPage({super.key, required this.manager});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  bool isLoading = false;
  List<InventoryItem> items = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.manager.getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    items = ref.watch(inventoryProvider).items;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          await goToPage(context, const AddInventoryItemPage());
          await widget.manager.getAllItems();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: lightColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 10),
                  suffix: SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(inventoryProvider).getItemsForQuery('');
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
                onChanged: (value) {
                  // filter the items
                  ref.read(inventoryProvider).getItemsForQuery(value);
                  // setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: LoadingWidget(
              isLoading: widget.manager.isLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  await widget.manager.getAllItems();
                  // items = ref.read(inventoryProvider).items;
                  // setState(() {});
                },
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
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
                      manager: widget.manager,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
