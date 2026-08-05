import 'package:flutter/material.dart';

class ActionItemModel {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  ActionItemModel(this.icon, this.label, this.color, {this.onTap});
}
