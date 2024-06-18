import 'dart:convert';

import 'package:collection/collection.dart';

enum ItemType { packaged, loose }

String getTypeFromEnum(ItemType type) {
  switch (type) {
    case ItemType.packaged:
      return 'packaged';
    case ItemType.loose:
      return 'loose';
  }
}

class InventoryItem {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double costPrice;
  final double sellingPrice;
  final double quantity;
  final String type;

  InventoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.type,
  });

  InventoryItem copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? images,
    double? costPrice,
    double? sellingPrice,
    double? quantity,
    String? type,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'images': images,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
      'type': type,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      images: List<String>.from(map['images']),
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      sellingPrice: map['sellingPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0,
      type: map['type'] ?? 'packaged',
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryItem.fromJson(String source) =>
      InventoryItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShopItem(id: $id, title: $title, description: $description, images: $images, costPrice: $costPrice, sellingPrice: $sellingPrice, quantity: $quantity, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is InventoryItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.images, images) &&
        other.costPrice == costPrice &&
        other.sellingPrice == sellingPrice &&
        other.type == type &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        images.hashCode ^
        costPrice.hashCode ^
        sellingPrice.hashCode ^
        type.hashCode ^
        quantity.hashCode;
  }
}
