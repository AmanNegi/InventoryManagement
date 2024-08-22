import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/core/transactions/application/transactions.dart";
import "package:inv_mgmt_client/core/transactions/presentation/transaction_detail_page.dart";
import "package:inv_mgmt_client/data/transaction_state.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/widgets/loading_widget.dart";

class TransactionsPage extends ConsumerStatefulWidget {
  final TransactionsManager manager;
  const TransactionsPage({super.key, required this.manager});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  @override
  void initState() {
    widget.manager.getAllTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: LoadingWidget(
        isLoading: widget.manager.isLoading,
        child: ListView.builder(
          itemBuilder: (context, index) {
            var transaction =
                ref.watch(transactionProvider).transactions[index];
            return ListTile(
              onTap: () {
                goToPage(
                  context,
                  TransactionDetailPage(transaction: transaction),
                );
              },
              leading: CircleAvatar(
                child: Text(transaction.buyerName[0]),
              ),
              title: Text(transaction.buyerName),
              subtitle: Text(transaction.totalAmount.toString()),
              trailing: Text(transaction.datedAt.toLocal().toString()),
            );
          },
          itemCount: ref.watch(transactionProvider).transactions.length,
        ),
      ),
    );
  }
}
