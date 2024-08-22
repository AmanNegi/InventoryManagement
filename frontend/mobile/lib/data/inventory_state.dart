import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';

//TODO: Use Later
final inventoryProvider =
    ChangeNotifierProvider<InventoryState>((ref) => InventoryState());

class InventoryState extends ChangeNotifier {
  List<InventoryItem> _items = [];
  List<InventoryItem> _allItems = [];

  List<InventoryItem> get items => _items;
  List<InventoryItem> get allItems => _allItems;

  List<InventoryItem> getItemsForQuery(String query) {
    if (query.trim().isEmpty) {
      return _allItems;
    }

    _items = _allItems
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
    return _items;
  }

  set allItems(List<InventoryItem> items) {
    _allItems = items;
    _items = items;
    notifyListeners();
  }

  addItem(InventoryItem item) {
    _allItems.add(item);
    notifyListeners();
  }

  removeItem(InventoryItem item) {
    _allItems.remove(item);
    notifyListeners();
  }

  updateItem(InventoryItem item) {
    int index = _allItems.indexWhere((element) => element.id == item.id);
    _allItems[index] = item;
    notifyListeners();
  }
}
