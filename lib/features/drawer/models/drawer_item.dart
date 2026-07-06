import 'package:flutter/material.dart';

class DrawerItem {
  final IconData icon;
  final String title;
  final bool isSelected;

  DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
  });
}
