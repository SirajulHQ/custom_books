import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  /// Calls POST /api/accounts/forgot-password/ with [email].
  ///
  /// Returns the decoded response map (with `_statusCode` attached) on any
  /// HTTP response, or `null` if the request could not be completed (network
  /// error, timeout, etc.).
  Future<Map<String, dynamic>?> forgotPassword({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/accounts/forgot-password/');

    try {
      appLog('➡️ Forgot-password request: $url', name: 'ForgotPasswordViewModel');

      final response = await http.post(
        url,
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      appLog(
        '📦 Forgot-password response (${response.statusCode}): ${response.body}',
        name: 'ForgotPasswordViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      resp['_statusCode'] = response.statusCode;

      return resp;
    } catch (e, stackTrace) {
      appLog(
        '❌ Forgot-password request error: $e',
        name: 'ForgotPasswordViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
