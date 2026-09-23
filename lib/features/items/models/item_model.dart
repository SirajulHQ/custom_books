class ItemModel {
  final String id;
  final String name;
  final String? sku;
  final double salesPrice;
  final double purchasePrice;
  final String? imageUrl;
  final bool isActive;

  // Extra fields from the API (optional, kept nullable for backward-compat).
  final String? organizationId;
  final String? itemType;
  final String? unit;
  final String? gtin;
  final String? status;
  final bool? salesEnabled;
  final bool? purchaseEnabled;
  final String? salesAccount;
  final String? salesDescription;
  final String? tax;
  final String? purchaseAccount;
  final String? purchaseDescription;
  final bool? trackInventory;
  final String? valuationMethod;
  final double? margin;
  final double? openingStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemModel({
    required this.id,
    required this.name,
    this.sku,
    required this.salesPrice,
    required this.purchasePrice,
    this.imageUrl,
    this.isActive = true,
    this.organizationId,
    this.itemType,
    this.unit,
    this.gtin,
    this.status,
    this.salesEnabled,
    this.purchaseEnabled,
    this.salesAccount,
    this.salesDescription,
    this.tax,
    this.purchaseAccount,
    this.purchaseDescription,
    this.trackInventory,
    this.valuationMethod,
    this.margin,
    this.openingStock,
    this.createdAt,
    this.updatedAt,
  });

  double get profit => salesPrice - purchasePrice;

  String get profitDisplay {
    return profit.toStringAsFixed(2);
  }

  /// Builds an [ItemModel] from a single API item object.
  ///
  /// The backend returns prices as strings (e.g. "15.00"), so numeric fields
  /// are parsed defensively. A blank `sku`/`unit` is normalised to `null` so
  /// the UI's "has value" checks behave correctly.
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: (json['item_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      sku: _nullIfBlank(json['sku']),
      salesPrice: _toDouble(json['selling_price']),
      purchasePrice: _toDouble(json['cost_price']),
      imageUrl: _nullIfBlank(json['image_url']),
      isActive:
          (json['status']?.toString().toLowerCase() ?? 'active') == 'active',
      organizationId: _nullIfBlank(json['organization_id']),
      itemType: _nullIfBlank(json['item_type']),
      unit: _nullIfBlank(json['unit']),
      gtin: _nullIfBlank(json['gtin']),
      status: _nullIfBlank(json['status']),
      salesEnabled: json['sales_enabled'] as bool?,
      purchaseEnabled: json['purchase_enabled'] as bool?,
      salesAccount: _nullIfBlank(json['sales_account']),
      salesDescription: _nullIfBlank(json['sales_description']),
      tax: _nullIfBlank(json['tax']),
      purchaseAccount: _nullIfBlank(json['purchase_account']),
      purchaseDescription: _nullIfBlank(json['purchase_description']),
      trackInventory: json['track_inventory'] as bool?,
      valuationMethod: _nullIfBlank(json['valuation_method']),
      margin: json['margin'] != null ? _toDouble(json['margin']) : null,
      openingStock: json['opening_stock'] != null
          ? _toDouble(json['opening_stock'])
          : null,
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String? _nullIfBlank(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
