import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class InventoryAdjustmentsListViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetchAdjustments({
    String? filter,
    String? sortBy,
    String? sortOrder,
  }) async {
    final url = Uri.parse('$baseUrl/api/inventory/adjustments/').replace(
      queryParameters: {
        if (filter != null && filter.isNotEmpty) 'filter': filter,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
      },
    );
    return _get(url, 'Adjustments');
  }

  Future<Map<String, dynamic>?> fetchAdjustmentDetail(
    String adjustmentId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/inventory/adjustments/',
    ).replace(queryParameters: {'adjustment_id': adjustmentId});
    return _get(url, 'Adjustment detail');
  }

  Future<Map<String, dynamic>?> _get(Uri url, String label) async {
    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog(
        '➡️ $label request: $url',
        name: 'InventoryAdjustmentsListViewModel',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 $label response (${response.statusCode}): ${response.body}',
        name: 'InventoryAdjustmentsListViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ $label request error: $e',
        name: 'InventoryAdjustmentsListViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
