import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

/// Handles create/update requests for a single inventory adjustment.
class InventoryAdjustmentFormViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> createAdjustment(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/api/inventory/adjustments/');

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog(
        '➡️ Create adjustment request: $url\n$body',
        name: 'InventoryAdjustmentFormViewModel',
      );

      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Create adjustment response (${response.statusCode}): ${response.body}',
        name: 'InventoryAdjustmentFormViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Create adjustment request error: $e',
        name: 'InventoryAdjustmentFormViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
