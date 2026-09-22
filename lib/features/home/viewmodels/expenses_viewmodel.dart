import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ExpensesViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetch({required String period}) async {
    final url = Uri.parse('$baseUrl/api/dashboard/expenses/').replace(
      queryParameters: {'period': period},
    );
    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Expenses request: $url', name: 'ExpensesViewModel');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      appLog('📦 Expenses (${response.statusCode}): ${response.body}', name: 'ExpensesViewModel');
      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog('❌ Expenses error: $e', name: 'ExpensesViewModel', error: e, stackTrace: st);
      return null;
    }
  }
}
