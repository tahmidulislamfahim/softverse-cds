class CdsBundleBreakdown {
  final String bundleName;
  final double bundlePrice;
  final String discountLabel;
  final double discountAmount;
  final double subtotal;

  const CdsBundleBreakdown({
    required this.bundleName,
    required this.bundlePrice,
    required this.discountLabel,
    required this.discountAmount,
    required this.subtotal,
  });

  factory CdsBundleBreakdown.fromJson(Map<String, dynamic> json) {
    return CdsBundleBreakdown(
      bundleName: json['name']?.toString() ?? '',
      bundlePrice: _money(json['price']),
      discountLabel: json['discountLabel']?.toString() ?? '',
      discountAmount: _money(json['discountAmount']),
      subtotal: _money(json['subtotal']),
    );
  }
}

class CdsPurchaseItemModel {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  final CdsBundleBreakdown? bundle;

  const CdsPurchaseItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    this.bundle,
  });

  factory CdsPurchaseItemModel.fromJson(Map<String, dynamic> json) {
    final bundleJson = json['bundle'];
    return CdsPurchaseItemModel(
      name: json['name']?.toString() ?? 'Item',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      price: _money(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? '',
      bundle: bundleJson is Map
          ? CdsBundleBreakdown.fromJson(bundleJson.cast<String, dynamic>())
          : null,
    );
  }
}

double _money(Object? value) => double.tryParse(value?.toString() ?? '') ?? 0;
