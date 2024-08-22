import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:inv_mgmt_client/data/cache/app_cache.dart";
import "package:inv_mgmt_client/data/inventory_state.dart";
import "package:inv_mgmt_client/globals.dart";
import 'package:inv_mgmt_client/models/inventory_item.dart';

class InventoryManager {
  final WidgetRef ref;
  final BuildContext context;

  InventoryManager(this.ref, this.context) {}

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  static bool validateItem({
    required String title,
    required double quantity,
    required double costPrice,
    required double sellingPrice,
  }) {
    if (title.isEmpty || quantity <= 0 || sellingPrice <= 0) {
      showToast("Please fill all fields");
      return false;
    }

    return true;
  }

  Future<int> addItem({
    required String title,
    required String description,
    required String? imageUrl,
    required double quantity,
    required double costPrice,
    required double sellingPrice,
    required String type,
  }) async {
    try {
      double cp = costPrice;
      if (cp <= 0) {
        cp = sellingPrice - (0.1 * sellingPrice);
      }

      var res = await http.post(
        Uri.parse("${API_URL}/list/addItem"),
        body: json.encode({
          "title": title,
          "description": description,
          "images": imageUrl == null ? [] : [imageUrl],
          "quantity": quantity,
          "costPrice": cp,
          "sellingPrice": sellingPrice,
          "type": type,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        showToast("Item added successfully");
        getAllItems();
        return 1;
      }

      showToast(res.body);
      print(res);
      return -1;
    } catch (e) {
      print(e);
      showToast("inventory.dart (addItem)" + e.toString());
      return -1;
    }
  }

  Future<int> deleteItem(String id) async {
    try {
      var res = await http.delete(Uri.parse("${API_URL}/list/deleteItem/$id"));

      if (res.statusCode == 200) {
        showToast("Item deleted successfully");
        getAllItems();
        return 1;
      }

      showToast(res.body);
      print(res.body);
      return -1;
    } catch (e) {
      print(e);
      showToast("inventory.dart (deleteItem):" + e.toString());
      return -1;
    }
  }

  Future<int> updateItem(InventoryItem item) async {
    try {
      var res = await http.put(
        Uri.parse("${API_URL}/list/updateItem/${item.id}"),
        body: json.encode({
          "title": item.title,
          "description": item.description,
          "images": item.images,
          "quantity": item.quantity,
          "costPrice": item.costPrice,
          "sellingPrice": item.sellingPrice,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        showToast("Item updated successfully");
        getAllItems();
        return 1;
      }

      showToast(res.body);
      print(res.body);
      return -1;
    } catch (e) {
      print("inventory.dart (updateItem): " + e.toString());
      showToast(e.toString());
      return -1;
    }
  }

  Future<void> getAllItems() async {
    if (ref.read(inventoryProvider).allItems.isEmpty) {
      isLoading.value = true;
    }
    try {
      var res = await http.get(Uri.parse("${API_URL}/list/getAll"));
      List<InventoryItem> shopItemList = [];

      if (res.statusCode == 200) {
        List items = json.decode(res.body);
        for (var e in items) {
          shopItemList.add(InventoryItem.fromMap(e));
        }

        print("Final list: $shopItemList");
        isLoading.value = false;

        ref.read(inventoryProvider).allItems = shopItemList;
        return;
      }

      isLoading.value = false;
      print(res.body);
    } catch (e) {
      isLoading.value = false;
      print("inventory.dart (getAllItems): " + e.toString());
    }
  }

  Future<InventoryItem?> getItem(String id) async {
    try {
      var res = await http.get(
        Uri.parse("${API_URL}/list/getItem/$id"),
      );

      if (res.statusCode == 200) {
        return InventoryItem.fromMap(json.decode(res.body));
      }

      showToast(res.body);
      print(res.body);
      return null;
    } catch (e) {
      print(e);
      showToast("inventory.dart (getItem):" + e.toString());
      return null;
    }
  }

//   router.get('/getItem/:id', async (req, res) => {
//   if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
//     return res.status(404).send('Invalid Item ID');
//   }
//   const item = await InventoryItem.findOne({ _id: req.params.id });
//   if (!item) {
//     return res.status(404).send('No Product Found');
//   }
//   return res.send(item);
// });
}
