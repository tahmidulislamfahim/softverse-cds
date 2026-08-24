import 'cds_purchase_item_model.dart';

class CdsOrderModel {
  final String orderNumber;
  final String companyName;
  final int totalItems;
  final double subtotal;
  final double tax;
  final double taxRatePercent;
  final double totalAmount;
  final double amountReceived;
  final double changeToReturn;
  final List<CdsPurchaseItemModel> items;

  const CdsOrderModel({
    required this.orderNumber,
    required this.companyName,
    required this.totalItems,
    required this.subtotal,
    required this.tax,
    required this.taxRatePercent,
    required this.totalAmount,
    required this.amountReceived,
    required this.changeToReturn,
    required this.items,
  });

  factory CdsOrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final items = itemsJson is List
        ? itemsJson
              .whereType<Map>()
              .map(
                (item) =>
                    CdsPurchaseItemModel.fromJson(item.cast<String, dynamic>()),
              )
              .toList()
        : const <CdsPurchaseItemModel>[];

    return CdsOrderModel(
      orderNumber: json['orderNumber']?.toString() ?? '',
      companyName: json['customerName']?.toString() ?? 'Not Registered',
      totalItems: items.fold(0, (sum, item) => sum + item.quantity),
      subtotal: _money(json['subtotal']),
      tax: _money(json['tax']),
      taxRatePercent: _money(json['taxRatePercent']),
      totalAmount: _money(json['totalAmount']),
      amountReceived: _money(json['amountReceived']),
      changeToReturn: _money(json['changeToReturn']),
      items: items,
    );
  }
}

double _money(Object? value) => double.tryParse(value?.toString() ?? '') ?? 0;
