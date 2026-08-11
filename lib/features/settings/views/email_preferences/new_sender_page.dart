import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:flutter/material.dart';

class NewSenderPage extends StatefulWidget {
  const NewSenderPage({super.key});

  @override
  State<NewSenderPage> createState() => _NewSenderPageState();
}

class _NewSenderPageState extends State<NewSenderPage>
    with UnsavedChangesMixin {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedEmail;

  final List<String> _availableEmails = ['miscellaneous4826@gmail.com'];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(markDirty);
    appLog('📧 NewSenderPage initialized', name: 'NewSender');
  }

  @override
  void dispose() {
    _nameController.removeListener(markDirty);
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Name is required');
      return;
    }
    if (_selectedEmail == null) {
      _showError('Email Address is required');
      return;
    }
    appLog(
      '💾 Save sender: ${_nameController.text} <$_selectedEmail>',
      name: 'NewSender',
    );
    markClean();
    Navigator.pop(context);
  }

  void _showError(String message) {
    ToastificationHelper.showError(context, message);
  }

  Future<void> _selectEmail() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Sender Email Address',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type to search or add email ...',
                        hintStyle: TextStyle(
                          color: context.colors.textTertiary,
                          fontSize: Dimensions.font16 * 0.85,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: context.colors.textTertiary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    width: Dimensions.height45 * 0.9,
                    height: Dimensions.height45 * 0.9,
                    decoration: BoxDecoration(
                      color: context.colors.textPrimary,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Icon(
                      Icons.add,
                      color: context.colors.background,
                      size: Dimensions.iconSize24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ..._availableEmails.map(
              (email) => ListTile(
                leading: CircleAvatar(
                  radius: Dimensions.radius20,
                  backgroundColor: Appcolors.warn.withValues(alpha: 0.1),
                  child: Text(
                    email.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      color: Appcolors.warn,
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.font16 * 0.75,
                    ),
                  ),
                ),
                title: Text(
                  email,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                  ),
                ),
                trailing: email == _selectedEmail
                    ? Icon(Icons.check_rounded, color: Appcolors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, email),
              ),
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _selectedEmail = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        bottomNavigationBar: _buildSaveButton(),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                title: 'New Sender',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      _buildLabel('Name', required: true),
                      SizedBox(height: Dimensions.height10),
                      _buildTextField(controller: _nameController, hint: ''),
                      SizedBox(height: Dimensions.height20),

                      // Email Address Field
                      _buildLabel('Email Address', required: true),
                      SizedBox(height: Dimensions.height10),
                      _buildDropdownField(
                        value: _selectedEmail,
                        hint: 'Choose sender email address',
                        onTap: _selectEmail,
                      ),
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

  Widget _buildLabel(String text, {bool required = false}) {
    if (required) {
      return Text.rich(
        TextSpan(
          text: '$text ',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
          children: [
            TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ],
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.85,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.9,
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textTertiary),
        filled: true,
        fillColor: context.colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: context.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: BorderSide(color: context.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          borderSide: const BorderSide(color: Appcolors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  color: value != null
                      ? context.colors.textPrimary
                      : context.colors.textTertiary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.height45,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.primary,
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
