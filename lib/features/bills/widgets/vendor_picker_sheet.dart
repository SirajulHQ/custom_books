import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class VendorPickerSheet extends StatelessWidget {
  final List<String> vendors;

  const VendorPickerSheet({super.key, required this.vendors});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.width15),
            child: Text(
              'Select Vendor',
              style: TextStyle(
                fontSize: Dimensions.font16 * 1.1,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...vendors.map(
                  (name) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Appcolors.primary.withValues(alpha: 0.1),
                      child: Text(
                        name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Appcolors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(color: context.colors.textPrimary),
                    ),
                    onTap: () => Navigator.pop(context, name),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
