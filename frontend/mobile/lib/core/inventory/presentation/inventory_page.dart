import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/core/inventory/application/inventory.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/add_inventory_page.dart';
import 'package:inv_mgmt_client/core/inventory/presentation/widgets/inventory_item_widget.dart';
import 'package:inv_mgmt_client/data/inventory_state.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';
import 'package:inv_mgmt_client/widgets/loading_widget.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  late InventoryManager manager;
  @override
  void initState() {
    manager = InventoryManager(ref, context);
    super.initState();
  }

  bool isLoading = false;
  List<InventoryItem> items = [];

  @override
  Widget build(BuildContext context) {
    items = ref.watch(inventoryProvider).items;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          goToPage(context, const AddInventoryItemPage());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: LoadingWidget(
        isLoading: manager.isLoading,
        child: RefreshIndicator(
          onRefresh: () async {
            await manager.getAllItems();
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
              return GridItem(item: items[index]);
            },
          ),
        ),
      ),
    );
  }

  GridView _getGridView(List<InventoryItem> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GridItem(item: items[index]);
      },
    );
  }
}
