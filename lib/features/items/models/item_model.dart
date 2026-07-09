class ItemModel {
  final String id;
  final String name;
  final String? sku;
  final double salesPrice;
  final double purchasePrice;
  final String? imageUrl;
  final bool isActive;

  ItemModel({
    required this.id,
    required this.name,
    this.sku,
    required this.salesPrice,
    required this.purchasePrice,
    this.imageUrl,
    this.isActive = true,
  });

  double get profit => salesPrice - purchasePrice;

  String get profitDisplay {
    return profit.toStringAsFixed(2);
  }
}
