import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A small pill-shaped drag indicator rendered at the top of every bottom sheet.
///
/// Zero parameters — sizing and colour come entirely from design tokens.
class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width20 * 2,
      height: Dimensions.height10 * 0.4,
      margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
    );
  }
}
