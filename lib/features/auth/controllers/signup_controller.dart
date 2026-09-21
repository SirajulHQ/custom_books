import 'package:custom_books/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../viewmodels/signup_viewmodel.dart';

class SignupController extends ChangeNotifier {
  final SignupViewModel _viewmodel = SignupViewModel();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _registerResponse;
  Map<String, dynamic>? get registerResponse => _registerResponse;

  /// Human-readable reason the last registration failed (null on success).
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _registerResponse = await _viewmodel.register(
      userType: userType,
      companyName: companyName,
      email: email,
      phoneCountryCode: phoneCountryCode,
      phone: phone,
      password: password,
      country: country,
      state: state,
      termsAccepted: termsAccepted,
    );

    final bool isSuccess =
        _registerResponse != null && _registerResponse!['success'] == true;

    if (!isSuccess) {
      _errorMessage = _extractErrorMessage(_registerResponse);
      appLog(
        '⚠️ Registration failed: $_errorMessage',
        name: 'SignupController',
      );
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  /// Builds a readable error string from the backend response.
  ///
  /// The API returns `{ "message": "...", "errors": { field: [msgs] } }`
  /// on validation failures. We prefer the specific field errors, falling
  /// back to the top-level message.
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

    return (response['message'] ?? 'Registration failed. Please try again.')
        .toString();
  }
}
