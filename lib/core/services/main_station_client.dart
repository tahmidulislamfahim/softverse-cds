import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../features/cds_home/models/cds_order_model.dart';
import 'storage_service.dart';

class MainStationEvent {
  final String type;
  final CdsOrderModel? cart;

  const MainStationEvent({required this.type, this.cart});
}

class MainStationClient {
  MainStationClient._();

  static final instance = MainStationClient._();
  static const port = 8787;

  static String normalize(String value) {
    var input = value.trim();
    if (input.isEmpty) return '';
    if (!input.startsWith('http://') && !input.startsWith('https://')) {
      input = 'http://$input';
    }

    final uri = Uri.parse(input);
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : port,
    ).toString();
  }

  Future<bool> test(String baseUrl) async {
    final url = normalize(baseUrl);
    if (url.isEmpty) return false;

    try {
      final response = await http
          .get(Uri.parse('$url/health'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Streams the live cart as it's built/paid/cleared at checkout, plus
  /// `connected`/`disconnected` lifecycle events for the connection badge.
  /// Reconnects automatically, resending a fresh snapshot each time.
  Stream<MainStationEvent> watchCart() async* {
    while (true) {
      final baseUrl = StorageService.mainStationUrl;
      if (baseUrl == null || baseUrl.isEmpty) {
        yield const MainStationEvent(type: 'disconnected');
        await Future.delayed(const Duration(seconds: 2));
        continue;
      }

      final httpUri = Uri.parse(baseUrl);
      final socketUri = httpUri.replace(
        scheme: httpUri.scheme == 'https' ? 'wss' : 'ws',
        path: '/cds/cart/stream',
      );

      try {
        final socket = await WebSocket.connect(
          socketUri.toString(),
        ).timeout(const Duration(seconds: 3));
        yield const MainStationEvent(type: 'connected');
        await for (final raw in socket) {
          final data = jsonDecode(raw.toString()) as Map<String, dynamic>;
          final type = data['type']?.toString() ?? '';
          if (type != 'cart_snapshot' &&
              type != 'cart_updated' &&
              type != 'checkout_completed' &&
              type != 'cart_cleared') {
            continue;
          }
          final cart = data['cart'];
          yield MainStationEvent(
            type: type,
            cart: cart is Map
                ? CdsOrderModel.fromJson(cart.cast<String, dynamic>())
                : null,
          );
        }
        yield const MainStationEvent(type: 'disconnected');
      } catch (_) {
        yield const MainStationEvent(type: 'disconnected');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
