import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class InvoiceFormHelpers {
  InvoiceFormHelpers._();

  static Widget buildSectionHeader(
    BuildContext context,
    String label, {
    bool hasInfo = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: Appcolors.primary,
          ),
        ),
        if (hasInfo) ...[
          SizedBox(width: Dimensions.width10 / 2),
          Icon(
            Icons.info_outline,
            size: Dimensions.iconSize16,
            color: context.colors.textTertiary,
          ),
        ],
      ],
    );
  }

  static Widget buildLinkRow(BuildContext context, List<Widget> links) {
    return Row(
      children: [
        for (int i = 0; i < links.length; i++) ...[
          if (i > 0) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: Text(
                '|',
                style: TextStyle(color: context.colors.textTertiary),
              ),
            ),
          ],
          links[i],
        ],
      ],
    );
  }

  static Widget buildLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          color: Appcolors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget buildTaxTreatmentRow(
    BuildContext context, {
    required String selectedTaxTreatment,
    required VoidCallback onEditTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tax Treatment',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: onEditTap,
              child: Icon(
                Icons.edit_outlined,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Text(
          selectedTaxTreatment,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  static Widget buildInvoiceNumberField(
    BuildContext context, {
    required String invoiceNumber,
    required VoidCallback onSettingsTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Invoice#',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
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
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Expanded(
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
                child: Text(
                  invoiceNumber,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: Dimensions.iconSize24,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }




  static Widget buildDateField(
    BuildContext context,
    String label,
    DateTime date, {
    bool isRequired = false,
    VoidCallback? onTap,
  }) {
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
          onTap: onTap,
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
                  '${date.day} ${getMonthName(date.month)} ${date.year}',
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

  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSeed(
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
    return picked;
  }

  static String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  static void showDropdownSheet(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> options,
    Function(String?)? onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20 * 1.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimensions.width20 * 2,
                height: Dimensions.height10 * 0.4,
                margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              ...options.map((option) {
                final selected = option == value;
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: Appcolors.primary)
                      : null,
                  onTap: () {
                    onChanged?.call(option);
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        );
      },
    );
  }
}
