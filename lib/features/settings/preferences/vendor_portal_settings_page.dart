import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class VendorPortalSettingsPage extends StatefulWidget {
  const VendorPortalSettingsPage({super.key});

  @override
  State<VendorPortalSettingsPage> createState() =>
      _VendorPortalSettingsPageState();
}

class _VendorPortalSettingsPageState extends State<VendorPortalSettingsPage> {
  bool _notifyVendorActivity = true;
  bool _notifyVendorsOnComment = true;
  bool _allowUpdateContactDetails = false;
  bool _allowAcceptRejectPO = false;
  bool _allowUploadDocuments = false;

  @override
  void initState() {
    super.initState();
    appLog(
      '🏪 VendorPortalSettingsPage initialized',
      name: 'VendorPortalSettings',
    );
  }

  void _save() {
    appLog('💾 Save Vendor Portal Settings', name: 'VendorPortalSettings');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      bottomNavigationBar: _buildSaveButton(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Vendor Portal Settings',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.height10),

                    // Notify me for vendor portal activity
                    _buildToggleSection(
                      title: 'Notify me for vendor portal activity',
                      description:
                          'Get notified via email when vendors add comments, updates custom fields or uploads documents.',
                      value: _notifyVendorActivity,
                      onChanged: (val) =>
                          setState(() => _notifyVendorActivity = val),
                    ),

                    _buildDivider(),

                    // Notify vendors when I comment
                    _buildToggleSection(
                      title:
                          'Notify my vendors when I comment or reject documents',
                      description:
                          'Vendors get an email when you comment or reject their documents.',
                      value: _notifyVendorsOnComment,
                      onChanged: (val) =>
                          setState(() => _notifyVendorsOnComment = val),
                    ),

                    _buildDivider(),

                    // Allow vendors to update contact details
                    _buildToggleSection(
                      title:
                          'Allow vendors to update contact details in portal',
                      description:
                          'Vendors can add or edit their addresses, custom fields, and contact info.',
                      value: _allowUpdateContactDetails,
                      onChanged: (val) =>
                          setState(() => _allowUpdateContactDetails = val),
                    ),

                    _buildDivider(),

                    // Allow vendors accept or reject purchase orders
                    _buildToggleSection(
                      title: 'Allow vendors accept or reject purchase orders',
                      description:
                          'Vendors can view purchase orders you send and accept or reject them.',
                      value: _allowAcceptRejectPO,
                      onChanged: (val) =>
                          setState(() => _allowAcceptRejectPO = val),
                    ),

                    _buildDivider(),

                    // Allow vendors to upload documents
                    _buildToggleSection(
                      title: 'Allow vendors to upload documents',
                      description:
                          'Vendors can upload invoices. You can verify and convert them to bills.',
                      value: _allowUploadDocuments,
                      onChanged: (val) =>
                          setState(() => _allowUploadDocuments = val),
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

  Widget _buildToggleSection({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: context.colors.border,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Divider(color: context.colors.border),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.height45,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
