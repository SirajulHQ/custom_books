import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class LoginViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/accounts/login/');

    try {
      appLog('➡️ Login request: $url', name: 'LoginViewModel');

      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      appLog(
        '📦 Login response (${response.statusCode}): ${response.body}',
        name: 'LoginViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      // Attach the HTTP status so the caller can distinguish success (2xx)
      // from auth failures (4xx) — this endpoint returns `{ "detail": ... }`
      // on failure and the JWT payload (`access`/`refresh`) on success.
      resp['_statusCode'] = response.statusCode;

      return resp;
    } catch (e, stackTrace) {
      appLog(
        '❌ Login request error: $e',
        name: 'LoginViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
