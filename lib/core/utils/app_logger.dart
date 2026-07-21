import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Application logger that only outputs in debug mode.
///
/// In release/profile builds all calls are no-ops, preventing
/// sensitive API request/response data from appearing in logcat.
///
/// Usage:
/// ```dart
/// import 'package:custom_books/core/utils/app_logger.dart';
/// appLog('✅ API call succeeded');
/// appLog('📦 Response: $body', name: 'MyFeature');
/// ```
void appLog(
  String message, {
  String name = 'CustomBooks',
  Object? error,
  StackTrace? stackTrace,
}) {
  if (kDebugMode) {
    developer.log(message, name: name, error: error, stackTrace: stackTrace);
  }
}
