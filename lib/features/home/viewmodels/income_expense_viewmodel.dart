import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class IncomeExpenseViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetch({
    required String period,
    required String accountingMethod,
  }) async {
    final url = Uri.parse('$baseUrl/api/dashboard/income-expense/').replace(
      queryParameters: {
        'period': period,
        'accounting_method': accountingMethod,
      },
    );
    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Income/expense request: $url', name: 'IncomeExpenseViewModel');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      appLog('📦 Income/expense (${response.statusCode}): ${response.body}', name: 'IncomeExpenseViewModel');
      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog('❌ Income/expense error: $e', name: 'IncomeExpenseViewModel', error: e, stackTrace: st);
      return null;
    }
  }
}
