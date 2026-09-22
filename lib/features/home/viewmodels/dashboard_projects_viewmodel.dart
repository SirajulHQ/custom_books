import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class DashboardProjectsViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> fetch() async {
    final url = Uri.parse('$baseUrl/api/dashboard/projects/');
    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog('➡️ Dashboard projects request: $url', name: 'DashboardProjectsViewModel');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      appLog('📦 Dashboard projects (${response.statusCode}): ${response.body}', name: 'DashboardProjectsViewModel');
      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog('❌ Dashboard projects error: $e', name: 'DashboardProjectsViewModel', error: e, stackTrace: st);
      return null;
    }
  }
}
