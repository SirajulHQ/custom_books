import 'package:flutter/material.dart';

/// Centralized color constants for invoice/template preview widgets.
/// These represent "printed document" colors and are intentionally fixed
/// (not theme-aware) to simulate a white-paper invoice appearance.
abstract final class TemplatePreviewColors {
  /// Primary text color for headings and values
  static const Color heading = Color(0xFF1A202C);

  /// Body text color for descriptions and addresses
  static const Color body = Color(0xFF4A5568);

  /// Secondary/label text color
  static const Color label = Color(0xFF718096);

  /// Medium emphasis text color
  static const Color medium = Color(0xFF2D3748);

  /// Light border color for containers
  static const Color border = Color(0xFFEEF2F6);

  /// Signature/divider line color
  static const Color divider = Color(0xFFCBD5E0);

  /// Background color for the document surface
  static const Color surface = Colors.white;
}
