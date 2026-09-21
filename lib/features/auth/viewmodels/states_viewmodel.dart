import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class StatesViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  /// Fetches the list of states for the given ISO-2 [country] code.
  ///
  /// The API responds with:
  /// `{ "success": true, "message": "Success",
  ///    "data": { "country": "US", "country_name": "...",
  ///              "phone_country_code": "+1", "states": [...] } }`
  /// on success, and `{ "success": false, "message": "Unsupported country." }`
  /// for countries without a state list.
  ///
  /// Returns the parsed body regardless of status so the caller can read the
  /// `success` flag and `data.states`. Returns null on a network/parse error.
  Future<Map<String, dynamic>?> fetchStates({required String country}) async {
    final url = Uri.parse(
      '$baseUrl/api/accounts/states/',
    ).replace(queryParameters: {'country': country});

    try {
      appLog('➡️ States request: $url', name: 'StatesViewModel');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      appLog(
        '📦 States response (${response.statusCode}): ${response.body}',
        name: 'StatesViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      return resp;
    } catch (e, stackTrace) {
      appLog(
        '❌ States request error: $e',
        name: 'StatesViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
