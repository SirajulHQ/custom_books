import 'package:intl/intl.dart';

/// Shared date format constant used across the app.
final DateFormat kDateFormat = DateFormat('dd MMM yyyy');

/// Format a [DateTime] to 'dd MMM yyyy' (e.g. "03 Jul 2026").
String formatDate(DateTime date) => kDateFormat.format(date);

/// Format a [DateTime] to 'dd MMM yyyy, hh:mm a' (e.g. "03 Jul 2026, 10:30 AM").
String formatDateTime(DateTime date) =>
    DateFormat('dd MMM yyyy, hh:mm a').format(date);
