import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ItemsListViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  /// Fetches the paginated list of items.
  ///
  /// Returns the parsed response body with `_statusCode` attached, or `null`
  /// if the request could not be completed (network error, etc.). The caller
  /// reads the `success` flag and `data.results` list.
  Future<Map<String, dynamic>?> fetchItems() async {
    final url = Uri.parse('$baseUrl/api/items/');

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
