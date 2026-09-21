import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

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
