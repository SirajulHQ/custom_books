import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final bool isRequired;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomDateField({
    super.key,
    required this.label,
    required this.date,
    this.isRequired = false,
    this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Appcolors.primary,
              brightness: Theme.of(context).brightness,
            ).copyWith(
              primary: Appcolors.primary,
              onSurface: context.colors.textPrimary,
              surface: context.colors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                '*',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: Dimensions.iconSize16,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}