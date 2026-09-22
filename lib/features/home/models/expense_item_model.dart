import 'package:flutter/material.dart';

class ExpenseItem {
  final String label;
  final double amount;
  final double percent;
  final Color color;

  ExpenseItem(this.label, this.amount, this.percent, this.color);

  factory ExpenseItem.fromJson(
    Map<String, dynamic> json, {
    Color fallbackColor = const Color(0xFF94A3B8),
  }) {
    // The API sends a hex color string e.g. "#2563EB" — parse it when present.
    final hexStr = json['color'] as String?;
    Color color = fallbackColor;
    if (hexStr != null && hexStr.startsWith('#') && hexStr.length == 7) {
      final hex = int.tryParse('FF${hexStr.substring(1)}', radix: 16);
      if (hex != null) color = Color(hex);
    }
    return ExpenseItem(
      json['label'] as String? ?? json['category'] as String? ?? '',
      double.tryParse(json['amount']?.toString() ?? '') ??
          (json['amount'] as num?)?.toDouble() ?? 0,
      double.tryParse(json['percentage']?.toString() ?? '') ??
          (json['percent'] as num?)?.toDouble() ?? 0,
      color,
    );
  }
}
