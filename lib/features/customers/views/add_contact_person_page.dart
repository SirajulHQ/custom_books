import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class AddContactPersonPage extends StatefulWidget {
  const AddContactPersonPage({super.key});

  @override
  State<AddContactPersonPage> createState() => _AddContactPersonPageState();
}

class _AddContactPersonPageState extends State<AddContactPersonPage> {
  String _selectedSalutation = '';

  final List<String> _salutationOptions = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Miss.',
    'Dr.',
  ];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _workPhoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  String _workPhoneCountryCode = '+91';
  String _mobileCountryCode = '+91';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _workPhoneController.dispose();
    _mobileController.dispose();
    _designationController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          CustomSliverAppBar(
            title: 'Add Contact Person',
            leadingType: AppBarLeadingType.back,
            onLeadingPressed: () {
              appLog('⬅️ Back button tapped', name: 'AddContactPersonPage');
              Navigator.pop(context);
            },
            actions: [
              AppBarIconButton(
                icon: Icons.contacts_outlined,
                color: context.colors.textSecondary,
                onPressed: () {
                  appLog(
                    '📱 Contacts button tapped',
                    name: 'AddContactPersonPage',
                  );
                  ToastificationHelper.showInfo(
                    context,
                    'Importing from device contacts is coming soon.',
                  );
                },
              ),
              SizedBox(width: Dimensions.width10),
              AppBarElevatedButton(
                label: 'SAVE',
                onPressed: () {
                  appLog('💾 Save button tapped', name: 'AddContactPersonPage');
                  ToastificationHelper.showSuccess(
                    context,
                    'Contact person saved.',
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.all(Dimensions.width20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Contact Person Card
                Container(
                  padding: EdgeInsets.all(Dimensions.width20),
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    border: Border.all(color: context.colors.border),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.border.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Person',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.95,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Row(
                        children: [
                          Expanded(flex: 1, child: _buildSalutationDropdown()),
                          SizedBox(width: Dimensions.width15),
                          Expanded(
                            flex: 2,
                            child: _buildSimpleTextField(
                              'First Name',
                              _firstNameController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),
                      _buildSimpleTextField('Last Name', _lastNameController),
                      SizedBox(height: Dimensions.height15),
                      _buildSimpleTextField(
                        'Email',
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Contact Phone',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.primary,
                        ),
                      ),
                      SizedBox(height: Dimensions.height15),
                      _buildPhoneField(
                        'Work Phone',
                        _workPhoneController,
                        _workPhoneCountryCode,
                        (value) =>
                            setState(() => _workPhoneCountryCode = value!),
                      ),
                      SizedBox(height: Dimensions.height15),
                      _buildPhoneField(
                        'Mobile',
                        _mobileController,
                        _mobileCountryCode,
                        (value) => setState(() => _mobileCountryCode = value!),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Other Details',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.primary,
                        ),
                      ),
                      SizedBox(height: Dimensions.height15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimpleTextField(
                              'Designation',
                              _designationController,
                            ),
                          ),
                          SizedBox(width: Dimensions.width15),
                          Expanded(
                            child: _buildSimpleTextField(
                              'Department',
                              _departmentController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Dimensions.height30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalutationDropdown() {
    return GestureDetector(
      onTap: () => _showSalutationBottomSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: _selectedSalutation.isEmpty
                ? context.colors.border
                : Appcolors.primary,
            width: _selectedSalutation.isEmpty ? 1 : 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _selectedSalutation.isEmpty
                    ? 'Salutation'
                    : _selectedSalutation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: _selectedSalutation.isEmpty
                      ? context.colors.textTertiary
                      : context.colors.textPrimary,
                  fontWeight: _selectedSalutation.isEmpty
                      ? FontWeight.w500
                      : FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: Dimensions.iconSize16 * 1.2,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showSalutationBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.colors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Salutation',
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.85,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      size: Dimensions.iconSize24,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Options
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(Dimensions.width20),
              itemCount: _salutationOptions.length,
              itemBuilder: (context, index) {
                final option = _salutationOptions[index];
                final isSelected = _selectedSalutation == option;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSalutation = option);
                    Navigator.pop(context);
                    appLog(
                      '✅ Salutation selected: $option',
                      name: 'AddContactPersonPage',
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height15,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Appcolors.primary.withValues(alpha: 0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border: Border.all(
                        color: isSelected
                            ? Appcolors.primary
                            : context.colors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? Appcolors.primary
                                : context.colors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Appcolors.primary,
                            size: Dimensions.iconSize24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTextField(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.85,
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.colors.textTertiary,
          fontSize: Dimensions.font16 * 0.85,
        ),
        filled: true,
        fillColor: context.colors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
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
          borderSide: BorderSide(color: Appcolors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildPhoneField(
    String label,
    TextEditingController controller,
    String countryCode,
    Function(String?) onCountryChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: Appcolors.primary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            GestureDetector(
              onTap: () => onCountryChanged(countryCode),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      countryCode,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: Dimensions.iconSize16 * 1.2,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(
                    color: context.colors.textTertiary,
                    fontSize: Dimensions.font16 * 0.85,
                  ),
                  filled: true,
                  fillColor: context.colors.surfaceLight,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height15,
                  ),
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
                    borderSide: BorderSide(color: Appcolors.primary, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
