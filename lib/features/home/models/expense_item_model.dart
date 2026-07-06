import 'package:flutter/material.dart';

class ExpenseItem {
  final String label;
  final double amount;
  final double percent;
  final Color color;

  ExpenseItem(this.label, this.amount, this.percent, this.color);
}
