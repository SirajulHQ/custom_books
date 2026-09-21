import 'package:custom_books/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordController extends ChangeNotifier {
  final ForgotPasswordViewModel _viewmodel = ForgotPasswordViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Set to `true` after a successful API response so the UI can show the
  /// confirmation screen.
  bool _emailSent = false;
  bool get emailSent => _emailSent;

  /// Human-readable error message from the last failed attempt, or `null`.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Sends a forgot-password request and returns `true` on success.
  Future<bool> sendResetLink({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _viewmodel.forgotPassword(email: email);

    final int? status = response?['_statusCode'] as int?;
    final bool isSuccess =
        response != null &&
        status != null &&
        status >= 200 &&
        status < 300 &&
        (response['success'] == true ||
            // Some backends return 200 with no explicit success field.
            (response['success'] == null && status == 200));

    if (isSuccess) {
      _emailSent = true;
      appLog(
        '✅ Password reset email sent successfully',
        name: 'ForgotPasswordController',
      );
    } else {
      _errorMessage = _extractErrorMessage(response);
      appLog(
        '⚠️ Forgot-password failed: $_errorMessage',
        name: 'ForgotPasswordController',
      );
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  /// Resets state so the user can try again with a different email.
  void reset() {
    _emailSent = false;
    _errorMessage = null;
    notifyListeners();
  }

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
            'Something went wrong. Please try again.')
        .toString();
  }
}
