import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ItemsViewModel {
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
      appLog('➡️ Items request: $url', name: 'ItemsViewModel');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Items response (${response.statusCode}): ${response.body}',
        name: 'ItemsViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Items request error: $e',
        name: 'ItemsViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Creates a new item via `POST /api/items/`.
  ///
  /// [body] must be the JSON payload the backend expects. Returns the parsed
  /// response body with `_statusCode` attached, or `null` on a network error.
  Future<Map<String, dynamic>?> createItem(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/items/');

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Create item request: $url', name: 'ItemsViewModel');

      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Create item response (${response.statusCode}): ${response.body}',
        name: 'ItemsViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Create item request error: $e',
        name: 'ItemsViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Updates an existing item via `PATCH /api/items/?item_id=<itemId>`.
  ///
  /// [body] carries the fields to change (same shape as create). Returns the
  /// parsed response body with `_statusCode` attached, or `null` on a network
  /// error.
  Future<Map<String, dynamic>?> updateItem(
    String itemId,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/items/',
    ).replace(queryParameters: {'item_id': itemId});

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Update item request: $url', name: 'ItemsViewModel');

      final response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Update item response (${response.statusCode}): ${response.body}',
        name: 'ItemsViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Update item request error: $e',
        name: 'ItemsViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
