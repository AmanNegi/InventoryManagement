import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';

class BillingItem {
  final InventoryItem item;
  final double quantity;

  BillingItem({required this.item, required this.quantity});
}

final billingNotifiers = [
  ChangeNotifierProvider<BillingState>((ref) => BillingState()),
  ChangeNotifierProvider<BillingState>((ref) => BillingState()),
  ChangeNotifierProvider<BillingState>((ref) => BillingState()),
];

class BillingState extends ChangeNotifier {
  List<BillingItem> _items = [];
  String _customerName = "";
  String _paymentMode = "cash";

  List<BillingItem> get items => _items;
  String get customerName => _customerName;
  String get paymentMode => _paymentMode;
  double discount = 0;

  set items(List<BillingItem> items) {
    _items = items;
    notifyListeners();
  }

  set customerName(String name) {
    _customerName = name;
    notifyListeners();
  }

  set paymentMode(String mode) {
    _paymentMode = mode;
    notifyListeners();
  }

  addItem(BillingItem item) {
    // check if item already exists and update quantity
    int index = _items.indexWhere((element) => element.item.id == item.item.id);
    if (index != -1) {
      _items[index] = BillingItem(
          item: item.item, quantity: _items[index].quantity + item.quantity);
      notifyListeners();
      return;
    }
    _items.add(item);
    notifyListeners();
  }

  removeItem(BillingItem item) {
    _items.remove(item);
    notifyListeners();
  }

  updateItem(BillingItem item) {
    int index = _items.indexWhere((element) => element.item.id == item.item.id);
    _items[index] = item;
    notifyListeners();
  }

  clearBill() {
    _items = [];
    _customerName = "";
    _paymentMode = "cash";
    notifyListeners();
  }

  double get totalAmount {
    return originalAmount - discount;
  }

  double get originalAmount {
    double total = 0;
    for (var item in _items) {
      if (item.item.type == "loose") {
        double pricePerGram = item.item.sellingPrice / 1000;
        total += (item.quantity * 1000) * pricePerGram;
      } else {
        total += item.item.sellingPrice * item.quantity;
      }
    }
    return total;
  }
}
