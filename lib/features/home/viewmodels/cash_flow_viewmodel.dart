import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class CashFlowViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetch({required String period}) async {
    final url = Uri.parse('$baseUrl/api/dashboard/cash-flow/').replace(
      queryParameters: {'period': period},
    );
    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Cash flow request: $url', name: 'CashFlowViewModel');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      appLog('📦 Cash flow (${response.statusCode}): ${response.body}', name: 'CashFlowViewModel');
      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog('❌ Cash flow error: $e', name: 'CashFlowViewModel', error: e, stackTrace: st);
      return null;
    }
  }
}
