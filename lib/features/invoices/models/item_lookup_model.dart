class ItemLookup {
  final String id;
  final String name;
  final double salesPrice;
  final String unit;
  final String? imageUrl;
  final double taxRate;

  const ItemLookup({
    required this.id,
    required this.name,
    required this.salesPrice,
    required this.unit,
    this.imageUrl,
    this.taxRate = 5.0,
  });
}
