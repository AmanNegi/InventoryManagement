import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:inv_mgmt_client/core/inventory/application/inventory.dart";
import "package:inv_mgmt_client/core/transactions/presentation/widgets/transaction_item_widget.dart";
import "package:inv_mgmt_client/globals.dart";
import "package:inv_mgmt_client/models/inventory_item.dart";
import "package:inv_mgmt_client/models/transaction_item.dart";

class TransactionDetailPage extends StatefulWidget {
  final TransactionItem transaction;
  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Detail"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          // ListTile(
          //   title: Text("Buyer Name"),
          //   subtitle: Text(widget.transaction.buyerName),
          // ),
          // ListTile(
          //   title: Text("Total Amount"),
          //   subtitle: Text(
          //       "Discount: " + widget.transaction.discountAmount.toString()),
          //   trailing: Text(widget.transaction.totalAmount.toString()),
          // ),
          // ListTile(
          //   title: Text("Discount Offerred"),
          //   subtitle: Text(widget.transaction.paymentStatus),
          // ),
          // ListTile(
          //   title: Text("Dated At"),
          //   subtitle: Text(widget.transaction.datedAt.toLocal().toString()),
          // ),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text("Buyer: ${widget.transaction.buyerName}")),
              Chip(
                  label: Text(
                      "Amount: ${widget.transaction.totalAmount + widget.transaction.discountAmount}")),
              Chip(
                  label:
                      Text("Discount: ${widget.transaction.discountAmount}")),
              Chip(label: Text("Total: ${widget.transaction.totalAmount}")),
              Chip(label: Text("Mode: ${widget.transaction.paymentMethod}")),
            ],
          ),
          Divider(),
          Text(
            "Items",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 0.01 * getHeight(context)),
          ...widget.transaction.items.map(
            (e) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Image.asset("assets/logo-1.png"),
                ),
                title: Text(
                  e.itemTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Quantity: ${e.quantity}"),
                trailing: Text("Price: ${e.price}"),
              );
            },
          ),
        ],
      ),
    );
  }
}
