import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/models/transaction_item.dart';

final transactionProvider =
    ChangeNotifierProvider<TransactionState>((ref) => TransactionState());

class TransactionState extends ChangeNotifier {
  List<TransactionItem> _transactions = [];

  List<TransactionItem> get transactions => _transactions;

  set transactions(List<TransactionItem> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  addTransaction(TransactionItem transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  removeTransaction(TransactionItem transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }
}
