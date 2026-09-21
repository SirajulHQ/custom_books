import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class SignupViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Future<Map<String, dynamic>?> register({
    required String userType,
    required String companyName,
    required String email,
    required String phoneCountryCode,
    required String phone,
    required String password,
    required String country,
    required String state,
    required bool termsAccepted,
  }) async {
    final url = Uri.parse('$baseUrl/api/accounts/register/');

    try {
      appLog('➡️ Register request: $url', name: 'SignupViewModel');

      final response = await http.post(
        url,
        body: jsonEncode({
          'user_type': userType,
          'company_name': companyName,
          'email': email,
          'phone_country_code': phoneCountryCode,
          'phone': phone,
          'password': password,
          'country': country,
          'state': state,
          'terms_accepted': termsAccepted,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      appLog(
        '📦 Register response (${response.statusCode}): ${response.body}',
        name: 'SignupViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      // Return the parsed body regardless of status so the caller can read
      // the `success` flag, `message`, and any field-level `errors`.
      return resp;
    } catch (e, stackTrace) {
      appLog(
        '❌ Register request error: $e',
        name: 'SignupViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
