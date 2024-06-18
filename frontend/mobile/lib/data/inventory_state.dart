import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';

//TODO: Use Later
final inventoryProvider =
    ChangeNotifierProvider<InventoryState>((ref) => InventoryState());

class InventoryState extends ChangeNotifier {
  List<InventoryItem> _items = [];

  List<InventoryItem> get items => _items;

  set items(List<InventoryItem> items) {
    _items = items;
    notifyListeners();
  }

  addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  removeItem(InventoryItem item) {
    _items.remove(item);
    notifyListeners();
  }

  updateItem(InventoryItem item) {
    int index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = item;
    notifyListeners();
  }
}
