import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ItemFormViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> createItem(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/api/items/');

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Create item request: $url', name: 'ItemFormViewModel');

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
        name: 'ItemFormViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Create item request error: $e',
        name: 'ItemFormViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateItem(
    String itemId,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/items/',
    ).replace(queryParameters: {'item_id': itemId});

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Update item request: $url', name: 'ItemFormViewModel');

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
        name: 'ItemFormViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Update item request error: $e',
        name: 'ItemFormViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteItem(String itemId) async {
    final url = Uri.parse(
      '$baseUrl/api/items/',
    ).replace(queryParameters: {'item_id': itemId});

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Delete item request: $url', name: 'ItemFormViewModel');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Delete item response (${response.statusCode}): ${response.body}',
        name: 'ItemFormViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Delete item request error: $e',
        name: 'ItemFormViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
