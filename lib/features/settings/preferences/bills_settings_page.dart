import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/settings/preferences/shared/add_custom_field_page.dart';
import 'package:flutter/material.dart';

class BillsSettingsPage extends StatefulWidget {
  const BillsSettingsPage({super.key});

  @override
  State<BillsSettingsPage> createState() => _BillsSettingsPageState();
}

class _BillsSettingsPageState extends State<BillsSettingsPage>
    with UnsavedChangesMixin {
  // Committed (saved) custom fields — the source of truth.
  final List<Map<String, dynamic>> _committedFields = [];

  // Working copy that add/remove edits operate on until the user saves.
  late List<Map<String, dynamic>> _customFields;

  @override
  void initState() {
    super.initState();
    _customFields = List<Map<String, dynamic>>.from(_committedFields);
    appLog('🧾 BillsSettingsPage initialized', name: 'BillsSettings');
  }

  void _addNewField() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddCustomFieldPage()),
    );
    if (result != null) {
      setState(() => _customFields.add(result));
      markDirty();
    }
  }

  void _save() {
    appLog('💾 Save Bills Settings', name: 'BillsSettings');
    _committedFields
      ..clear()
      ..addAll(_customFields);
    markClean();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                title: 'Bills',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                  SizedBox(width: Dimensions.width20),
                ],
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
              markDirty();
            },
          ),
        ],
      ),
    );
  }
}
