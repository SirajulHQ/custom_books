import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ItemDetailViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  /// Fetches a single item via `GET /api/items/?item_id=<itemId>`.
  ///
  /// Returns the parsed response body with `_statusCode` attached, or `null`
  /// on a network error.
  Future<Map<String, dynamic>?> fetchItem(String itemId) async {
    final url = Uri.parse(
      '$baseUrl/api/items/',
    ).replace(queryParameters: {'item_id': itemId});

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Item detail request: $url', name: 'ItemDetailViewModel');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Item detail response (${response.statusCode}): ${response.body}',
        name: 'ItemDetailViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Item detail request error: $e',
        name: 'ItemDetailViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
