import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ItemsListViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetchItems({
    String? filter,
    String? sortBy,
    String? sortOrder,
  }) async {
    final url = Uri.parse('$baseUrl/api/items/').replace(
      queryParameters: {
        if (filter != null && filter.isNotEmpty) 'filter': filter,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
      },
    );

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Items request: $url', name: 'ItemsListViewModel');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Items response (${response.statusCode}): ${response.body}',
        name: 'ItemsListViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Items request error: $e',
        name: 'ItemsListViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
