import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;
import 'package:inv_mgmt_client/data/transaction_state.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/models/transaction_item.dart';

class TransactionsManager {
  WidgetRef ref;
  BuildContext context;

  TransactionsManager(this.ref, this.context);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<List<TransactionItem>> getAllTransactions() async {
    isLoading.value = true;
    try {
      List<TransactionItem> transactions = [];

      var res = await http.get(Uri.parse("$API_URL/transactions/all"));
      isLoading.value = false;

      if (res.statusCode == 200) {
        List data = json.decode(res.body);
        for (var item in data) {
          transactions.add(TransactionItem.fromMap(item));
        }
      } else {
        showToast(res.body);
      }

      ref.read(transactionProvider).transactions = transactions;
      return transactions;
    } catch (e) {
      isLoading.value = false;
      showToast(e.toString());
      print(e);
      return [];
    }
  }
}
