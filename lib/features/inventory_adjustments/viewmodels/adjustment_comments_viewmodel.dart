import 'dart:convert';

import 'package:custom_books/core/secrets/api_secrets.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

/// Handles the comments & history endpoint for an inventory adjustment.
class AdjustmentCommentsViewModel {
  final String baseUrl = ApiSecrets.baseUrl;

  Uri _url(String adjustmentId) => Uri.parse(
    '$baseUrl/api/inventory/adjustments/comments/',
  ).replace(queryParameters: {'adjustment_id': adjustmentId});

  Future<Map<String, dynamic>?> fetchComments(String adjustmentId) async {
    final url = _url(adjustmentId);

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog(
        '➡️ Comments request: $url',
        name: 'AdjustmentCommentsViewModel',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Comments response (${response.statusCode}): ${response.body}',
        name: 'AdjustmentCommentsViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Comments request error: $e',
        name: 'AdjustmentCommentsViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> addComment(
    String adjustmentId,
    String comment,
  ) async {
    final url = _url(adjustmentId);

    try {
      final token = await AuthService.instance.getValidAccessToken();
      appLog(
        '➡️ Add comment request: $url',
        name: 'AdjustmentCommentsViewModel',
      );

      final response = await http.post(
        url,
        body: jsonEncode({'comment': comment}),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      appLog(
        '📦 Add comment response (${response.statusCode}): ${response.body}',
        name: 'AdjustmentCommentsViewModel',
      );

      final Map<String, dynamic> resp = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      resp['_statusCode'] = response.statusCode;
      return resp;
    } catch (e, st) {
      appLog(
        '❌ Add comment request error: $e',
        name: 'AdjustmentCommentsViewModel',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
