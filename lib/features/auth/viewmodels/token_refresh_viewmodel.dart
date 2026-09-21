import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class TokenRefreshViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  /// Exchanges a valid refresh token for a new access token.
  ///
  /// SimpleJWT returns `{ "access": "..." }` on success and
  /// `{ "detail": "...", "code": "token_not_valid" }` (HTTP 401) when the
  /// refresh token is expired or invalid.
  Future<Map<String, dynamic>?> refresh({required String refreshToken}) async {
    final url = Uri.parse('$baseUrl/api/accounts/token/refresh/');

    try {
      appLog('➡️ Token refresh request: $url', name: 'TokenRefreshViewModel');

      final response = await http.post(
        url,
        body: jsonEncode({'refresh': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      appLog(
        '📦 Token refresh response (${response.statusCode})',
        name: 'TokenRefreshViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, stackTrace) {
      appLog(
        '❌ Token refresh request error: $e',
        name: 'TokenRefreshViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
