import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class DashboardOverviewViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetch() async {
    final url = Uri.parse('$baseUrl/api/dashboard/');

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Dashboard overview request: $url', name: 'DashboardOverviewViewModel');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Dashboard overview response (${response.statusCode}): ${response.body}',
        name: 'DashboardOverviewViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog('❌ Dashboard overview error: $e', name: 'DashboardOverviewViewModel', error: e, stackTrace: st);
      return null;
    }
  }
}
