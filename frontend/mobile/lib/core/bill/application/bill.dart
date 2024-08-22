import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inv_mgmt_client/data/billing_state.dart';
import 'package:inv_mgmt_client/data/cache/app_cache.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/inventory_item.dart';

class BillManager {
  WidgetRef ref;
  BuildContext context;

  BillManager(this.ref, this.context);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<int> createBill({
    required double totalAmount,
    required double discountAmount,
    required String customerName,
    required String paymentMethod,
    required List<BillingItem> items,
  }) async {
    isLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse("${API_URL}/transactions/add"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "totalAmount": totalAmount,
          "buyerName": customerName.isEmpty ? "Anonymous" : customerName,
          "biller": appState.value.user != null
              ? appState.value.user!.name
              : "app-client",
          "items": items.map((e) {
            return {
              "itemTitle": e.item.title,
              "itemId": e.item.id,
              "price": e.item.sellingPrice,
              "quantity": e.quantity,
            };
          }).toList(),
          "paymentMethod": paymentMethod,
          "discountAmount": discountAmount,
        }),
      );
      isLoading.value = false;

      if (response.statusCode == 200) {
        showToast("Bill created successfully!");
        return 1;
      } else {
        showToast(response.body);
        return -1;
      }
    } catch (error) {
      isLoading.value = false;
      showToast(error.toString());
      print("bill.dart (createBill): " + error.toString());
      return -1;
    }
  }
}
