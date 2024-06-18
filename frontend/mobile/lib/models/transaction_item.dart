import 'dart:convert';

import 'package:collection/collection.dart';

class TransactionItem {
  final String id;
  final double totalAmount;
  final String buyerName;
  final String biller;
  final DateTime datedAt;
  final List<TransactionItemDetails> items;
  TransactionItem({
    required this.id,
    required this.totalAmount,
    required this.buyerName,
    required this.biller,
    required this.datedAt,
    required this.items,
  });

  TransactionItem copyWith({
    String? id,
    double? totalAmount,
    String? buyerName,
    String? biller,
    DateTime? datedAt,
    List<TransactionItemDetails>? items,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      buyerName: buyerName ?? this.buyerName,
      biller: biller ?? this.biller,
      datedAt: datedAt ?? this.datedAt,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'totalAmount': totalAmount,
      'buyerName': buyerName,
      'biller': biller,
      'datedAt': datedAt.toIso8601String(),
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['_id'] ?? '',
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      buyerName: map['buyerName'] ?? '',
      biller: map['biller'] ?? '',
      datedAt: DateTime.parse(map['datedAt']),
      items: List<TransactionItemDetails>.from(
          map['items']?.map((x) => TransactionItemDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionItem.fromJson(String source) =>
      TransactionItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionItem(id: $id, totalAmount: $totalAmount, buyerName: $buyerName, biller: $biller, datedAt: $datedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is TransactionItem &&
        other.id == id &&
        other.totalAmount == totalAmount &&
        other.buyerName == buyerName &&
        other.biller == biller &&
        other.datedAt == datedAt &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        totalAmount.hashCode ^
        buyerName.hashCode ^
        biller.hashCode ^
        datedAt.hashCode ^
        items.hashCode;
  }
}

class TransactionItemDetails {
  final String itemTitle;
  final String itemId;
  final double price;
  final double quantity;
  TransactionItemDetails({
    required this.itemTitle,
    required this.itemId,
    required this.price,
    required this.quantity,
  });

  TransactionItemDetails copyWith({
    String? itemTitle,
    String? itemId,
    double? price,
    double? quantity,
  }) {
    return TransactionItemDetails(
      itemTitle: itemTitle ?? this.itemTitle,
      itemId: itemId ?? this.itemId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemTitle': itemTitle,
      'itemId': itemId,
      'price': price,
      'quantity': quantity,
    };
  }

  factory TransactionItemDetails.fromMap(Map<String, dynamic> map) {
    return TransactionItemDetails(
      itemTitle: map['itemTitle'] ?? '',
      itemId: map['itemId'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionItemDetails.fromJson(String source) =>
      TransactionItemDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionItemDetails(itemTitle: $itemTitle, itemId: $itemId, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionItemDetails &&
        other.itemTitle == itemTitle &&
        other.itemId == itemId &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return itemTitle.hashCode ^
        itemId.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}
