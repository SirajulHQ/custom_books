import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/preferences/shared/add_custom_field_page.dart';
import 'package:flutter/material.dart';

class BillsSettingsPage extends StatefulWidget {
  const BillsSettingsPage({super.key});

  @override
  State<BillsSettingsPage> createState() => _BillsSettingsPageState();
}

class _BillsSettingsPageState extends State<BillsSettingsPage> {
  final List<Map<String, dynamic>> _customFields = [];

  @override
  void initState() {
    super.initState();
    appLog('🧾 BillsSettingsPage initialized', name: 'BillsSettings');
  }

  void _addNewField() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddCustomFieldPage()),
    );
    if (result != null) {
      setState(() => _customFields.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Bills',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.height15),

                    // Fields Section
                    Text(
                      'Fields',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    // Custom fields list
                    ..._customFields.map(
                      (field) => _buildCustomFieldTile(field),
                    ),

                    // Add new field
                    InkWell(
                      onTap: _addNewField,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        child: Text(
                          'Add new field',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.height30 * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFieldTile(Map<String, dynamic> field) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label'] ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  field['dataType'] ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.warn,
              size: Dimensions.iconSize24,
            ),
            onPressed: () {
              setState(() => _customFields.remove(field));
            },
          ),
        ],
      ),
    );
  }
}
