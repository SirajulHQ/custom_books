import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemSettingsPage extends StatefulWidget {
  const ItemSettingsPage({super.key});

  @override
  State<ItemSettingsPage> createState() => _ItemSettingsPageState();
}

class _ItemSettingsPageState extends State<ItemSettingsPage> {
  bool _enableInventory = true;
  DateTime _inventoryStartDate = DateTime(2026, 6, 3);
  bool _notifyReorderPoint = false;

  @override
  void initState() {
    super.initState();
    appLog('📦 ItemSettingsPage initialized', name: 'ItemSettings');
  }

  void _save() {
    appLog('💾 Save Item Settings', name: 'ItemSettings');
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inventoryStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _inventoryStartDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Item Settings',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormCard(
                      children: [
                        // Inventory Header
                        Text(
                          'Inventory',
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Enable Inventory Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Would you like to enable Inventory?',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ),
                            Switch(
                              value: _enableInventory,
                              onChanged: (val) =>
                                  setState(() => _enableInventory = val),
                              activeColor: AppColors.primary,
                            ),
                          ],
                        ),

                        if (_enableInventory) ...[
                          SizedBox(height: Dimensions.height15),

                          // Inventory Start Date
                          Text(
                            'Inventory Start Date',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.8,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warn,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          InkWell(
                            onTap: _pickDate,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height10,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: context.colors.border,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateFormat.format(_inventoryStartDate),
                                    style: FormTextStyles.value(context),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: Dimensions.iconSize24 * 0.85,
                                    color: context.colors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),

                          // Notify Reorder Point
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Do you want to get notified when an item quantity drops below reorder point?',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ),
                              Switch(
                                value: _notifyReorderPoint,
                                onChanged: (val) =>
                                    setState(() => _notifyReorderPoint = val),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
