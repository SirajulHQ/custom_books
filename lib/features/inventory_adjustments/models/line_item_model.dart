enum ModeOfAdjustment { quantity, value }

class InventoryItemLookup {
  final String id;
  final String name;
  final double stockOnHand;
  final String? imageUrl;
  final double costPrice;

  const InventoryItemLookup({
    required this.id,
    required this.name,
    required this.stockOnHand,
    this.imageUrl,
    this.costPrice = 0,
  });
}

class LineItem {
  final String id;
  final String itemId;
  final String itemName;
  final String? description;
  final String? imageUrl;
  final double stockOnHand;
  final double newQuantityOnHand;
  final double quantityAdjusted;
  final double costPrice;

  const LineItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.description,
    this.imageUrl,
    required this.stockOnHand,
    required this.newQuantityOnHand,
    required this.quantityAdjusted,
    required this.costPrice,
  });

  /// Value impact of this line = quantity change * cost price.
  double get valueChange => quantityAdjusted * costPrice;

  LineItem copyWith({
    String? description,
    double? newQuantityOnHand,
    double? quantityAdjusted,
    double? costPrice,
  }) {
    return LineItem(
      id: id,
      itemId: itemId,
      itemName: itemName,
      description: description ?? this.description,
      imageUrl: imageUrl,
      stockOnHand: stockOnHand,
      newQuantityOnHand: newQuantityOnHand ?? this.newQuantityOnHand,
      quantityAdjusted: quantityAdjusted ?? this.quantityAdjusted,
      costPrice: costPrice ?? this.costPrice,
    );
  }
}
