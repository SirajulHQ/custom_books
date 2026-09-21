import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../viewmodels/login_viewmodel.dart';

class LoginController extends ChangeNotifier {
  final LoginViewModel _viewmodel = LoginViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _loginResponse;
  Map<String, dynamic>? get loginResponse => _loginResponse;

  /// Human-readable reason the last login failed (null on success).
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// JWT tokens returned by the API on a successful login.
  String? get accessToken => _loginResponse?['access'] as String?;
  String? get refreshToken => _loginResponse?['refresh'] as String?;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _loginResponse = await _viewmodel.login(email: email, password: password);

    final int? status = _loginResponse?['_statusCode'] as int?;
    final bool isSuccess =
        _loginResponse != null &&
        status != null &&
        status >= 200 &&
        status < 300 &&
        _loginResponse!['access'] != null;

    if (isSuccess) {
      // Persist the token pair so the session survives restarts and the
      // access token can be auto-refreshed once it expires.
      await AuthService.instance.saveSession(
        access: _loginResponse!['access'] as String,
        refresh: (_loginResponse!['refresh'] ?? '') as String,
      );
    } else {
      _errorMessage = _extractErrorMessage(_loginResponse);
      appLog('⚠️ Login failed: $_errorMessage', name: 'LoginController');
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  /// Builds a readable error string from the backend response.
  ///
  /// This endpoint returns `{ "detail": "..." }` on auth failure and may
  /// return `{ "message": ..., "errors": { field: [msgs] } }` on validation
  /// errors. We prefer field errors, then `detail`, then `message`.
  String _extractErrorMessage(Map<String, dynamic>? response) {
    if (response == null) {
      return 'Could not reach the server. Check your connection and try again.';
    }

    final errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final parts = <String>[];
      errors.forEach((field, messages) {
        if (messages is List && messages.isNotEmpty) {
          parts.add(messages.first.toString());
        } else if (messages != null) {
          parts.add(messages.toString());
        }
      });
      if (parts.isNotEmpty) return parts.join('\n');
    }

    return (response['detail'] ??
            response['message'] ??
            'Login failed. Please try again.')
        .toString();
  }
}
