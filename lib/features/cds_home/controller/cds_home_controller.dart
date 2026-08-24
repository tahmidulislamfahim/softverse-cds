import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/main_station_client.dart';
import '../models/cds_order_model.dart';

enum CdsConnectionState { active, idle, disconnected }

class CdsHomeController extends GetxController {
  final posLabel = 'POS-1';
  final connectionState = CdsConnectionState.disconnected.obs;
  final order = Rxn<CdsOrderModel>();

  StreamSubscription<MainStationEvent>? _cartStream;
  Timer? _receiptHoldTimer;

  @override
  void onInit() {
    super.onInit();
    _cartStream = MainStationClient.instance.watchCart().listen(_handleEvent);
  }

  @override
  void onClose() {
    _cartStream?.cancel();
    _receiptHoldTimer?.cancel();
    super.onClose();
  }

  void reconnect() {
    _cartStream?.cancel();
    _cartStream = MainStationClient.instance.watchCart().listen(_handleEvent);
  }

  void _handleEvent(MainStationEvent event) {
    switch (event.type) {
      case 'connected':
        connectionState.value = CdsConnectionState.active;
      case 'disconnected':
        connectionState.value = CdsConnectionState.disconnected;
      case 'cart_snapshot':
      case 'cart_updated':
        _receiptHoldTimer?.cancel();
        order.value = event.cart;
      case 'checkout_completed':
        order.value = event.cart;
        _receiptHoldTimer?.cancel();
        // ponytail: fixed hold, make configurable if a real store asks for it.
        _receiptHoldTimer = Timer(
          const Duration(seconds: 8),
          () => order.value = null,
        );
      case 'cart_cleared':
        _receiptHoldTimer?.cancel();
        order.value = null;
    }
  }
}
