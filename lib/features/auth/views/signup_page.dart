import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/form_validators.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/features/auth/controllers/signup_controller.dart';
import 'package:custom_books/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _signupController = SignupController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // ─── user_type ───────────────────────────────────────────────
  // Maps the API values to their display labels.
  static const List<_UserTypeOption> _userTypes = [
    _UserTypeOption(value: 'business_user', label: 'Business User'),
    _UserTypeOption(value: 'tax_consultant', label: 'Tax Consultant'),
    _UserTypeOption(value: 'student', label: 'Student/Learner'),
  ];
  String _userType = _userTypes.first.value;

  // ─── country ─────────────────────────────────────────────────
  // `code` is the ISO-2 code sent to the API, `label` is shown to the user,
  // and `phoneCode` is the matching dial code (phone_country_code).
  static const List<_CountryOption> _countries = [
    _CountryOption(code: 'IN', label: 'India', phoneCode: '+91'),
    _CountryOption(code: 'US', label: 'United States', phoneCode: '+1'),
    _CountryOption(code: 'GB', label: 'United Kingdom', phoneCode: '+44'),
    _CountryOption(
      code: 'AE',
      label: 'United Arab Emirates',
      phoneCode: '+971',
    ),
    _CountryOption(code: 'SA', label: 'Saudi Arabia', phoneCode: '+966'),
    _CountryOption(code: 'CA', label: 'Canada', phoneCode: '+1'),
    _CountryOption(code: 'AU', label: 'Australia', phoneCode: '+61'),
    _CountryOption(code: 'SG', label: 'Singapore', phoneCode: '+65'),
    _CountryOption(code: 'MY', label: 'Malaysia', phoneCode: '+60'),
    _CountryOption(code: 'PK', label: 'Pakistan', phoneCode: '+92'),
    _CountryOption(code: 'BD', label: 'Bangladesh', phoneCode: '+880'),
    _CountryOption(code: 'LK', label: 'Sri Lanka', phoneCode: '+94'),
    _CountryOption(code: 'NP', label: 'Nepal', phoneCode: '+977'),
  ];
  String _country = 'IN';

  // ─── phone_country_code ──────────────────────────────────────
  // Always derived from the selected country so the two stay in sync.
  String get _phoneCountryCode => _countries
      .firstWhere((c) => c.code == _country, orElse: () => _countries.first)
      .phoneCode;

  // ─── state ───────────────────────────────────────────────────
  // Only India has a defined state list; other countries use a free-form
  // state entry instead of a dropdown.
  static const List<String> _indiaStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];
  String? _state = 'Kerala';
  final _stateController = TextEditingController();

  bool get _isIndia => _country == 'IN';

  bool _obscurePassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _signupController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  /// Keeps country + state in sync. India uses the dropdown value; other
  /// countries use the free-form text field.
  String get _resolvedState =>
      _isIndia ? (_state ?? '') : _stateController.text.trim();

  void _onCountryChanged(String? code) {
    setState(() {
      _country = code ?? 'IN';
      // Reset state when switching to/from India so a stale value can't be
      // sent for the wrong country.
      if (_isIndia) {
        _state = _indiaStates.contains(_state) ? _state : null;
      }
    });
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      appLog('⚠️ Terms not accepted', name: 'SignupPage');
      ToastificationHelper.showWarning(
        context,
        'Please accept the Terms of Service and Privacy Policy',
      );
      return;
    }

    appLog('📝 Sign up tapped', name: 'SignupPage');
    appLog('   User type: $_userType', name: 'SignupPage');
    appLog(
      '   Company: ${_companyNameController.text.trim()}',
      name: 'SignupPage',
    );
    appLog('   Email: ${_emailController.text.trim()}', name: 'SignupPage');
    appLog(
      '   Phone: $_phoneCountryCode ${_phoneController.text.trim()}',
      name: 'SignupPage',
    );
    appLog('   Country: $_country, State: $_state', name: 'SignupPage');

    final success = await _signupController.register(
      userType: _userType,
      companyName: _companyNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneCountryCode: _phoneCountryCode,
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      country: _country,
      state: _resolvedState,
      termsAccepted: _termsAccepted,
    );

    if (!mounted) return;

    if (success) {
      final message = _signupController.registerResponse?['message'] as String?;
      appLog('✅ Registration successful', name: 'SignupPage');
      ToastificationHelper.showSuccess(
        context,
        message ?? 'Registration successful.',
      );
      _navigateToLogin();
    } else {
      final error =
          _signupController.errorMessage ??
          'Registration failed. Please try again.';
      appLog('❌ Registration failed: $error', name: 'SignupPage');
      ToastificationHelper.showError(context, error);
    }
  }

  void _navigateToLogin() {
    // If Signup was pushed on top of Login, just pop back to the existing
    // Login page instead of stacking a new one.
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.height20),

                  // Title
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: Dimensions.font26,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: context.colors.textSecondary,
                    ),
                  ),

                  SizedBox(height: Dimensions.height30),

                  // "Who are you signing up as?" — user_type selector
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Who are you signing up as?',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    children: [
                      for (int i = 0; i < _userTypes.length; i++) ...[
                        Expanded(
                          child: _UserTypeCard(
                            option: _userTypes[i],
                            selected: _userType == _userTypes[i].value,
                            onTap: () =>
                                setState(() => _userType = _userTypes[i].value),
                          ),
                        ),
                        if (i != _userTypes.length - 1)
                          SizedBox(width: Dimensions.width10),
                      ],
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Company Name field
                  TextFormField(
                    controller: _companyNameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: _inputDecoration(
                      context,
                      label: 'Company Name',
                      icon: Icons.business_outlined,
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: _inputDecoration(
                      context,
                      label: 'Email address',
                      icon: Icons.email_outlined,
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Phone field with country code prefix
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: FormValidators.validatePhone,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: _inputDecoration(
                      context,
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      prefix: Padding(
                        padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                        child: Text(
                          _phoneCountryCode,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: FormValidators.validatePassword,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: _inputDecoration(
                      context,
                      label: 'Password',
                      icon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: context.colors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Country & State row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _country,
                          isExpanded: true,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: Dimensions.font16,
                          ),
                          dropdownColor: context.colors.card,
                          decoration: _inputDecoration(
                            context,
                            label: 'Country',
                            icon: Icons.public_outlined,
                          ),
                          items: [
                            for (final c in _countries)
                              DropdownMenuItem(
                                value: c.code,
                                child: Text(
                                  c.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: _onCountryChanged,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        // India → dropdown of states; other countries →
                        // free-form entry since no fixed state list applies.
                        child: _isIndia
                            ? DropdownButtonFormField<String>(
                                initialValue: _state,
                                isExpanded: true,
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: Dimensions.font16,
                                ),
                                dropdownColor: context.colors.card,
                                decoration: _inputDecoration(
                                  context,
                                  label: 'State',
                                  icon: Icons.location_on_outlined,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Select a state'
                                    : null,
                                items: [
                                  for (final s in _indiaStates)
                                    DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                                onChanged: (v) => setState(() => _state = v),
                              )
                            : TextFormField(
                                controller: _stateController,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'State is required'
                                    : null,
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: Dimensions.font16,
                                ),
                                decoration: _inputDecoration(
                                  context,
                                  label: 'State',
                                  icon: Icons.location_on_outlined,
                                ),
                              ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Terms accepted checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Dimensions.iconSize24,
                        height: Dimensions.iconSize24,
                        child: Checkbox(
                          value: _termsAccepted,
                          activeColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _termsAccepted = v ?? false),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'I agree to the ',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                color: context.colors.textSecondary,
                              ),
                            ),
                            Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              ' and ',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                color: context.colors.textSecondary,
                              ),
                            ),
                            Text(
                              'Privacy Policy.',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Sign Up button
                  ListenableBuilder(
                    listenable: _signupController,
                    builder: (context, _) {
                      final isLoading = _signupController.isLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: Dimensions.height52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.primary
                                .withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: Dimensions.iconSize22,
                                  height: Dimensions.iconSize22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create my account',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Already have an account? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    Widget? prefix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.colors.textSecondary),
      prefixIcon: Icon(icon, color: context.colors.textSecondary),
      prefix: prefix,
      suffixIcon: suffixIcon,
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Helper models & widgets
// ─────────────────────────────────────────────────────────────────────

class _UserTypeOption {
  final String value;
  final String label;
  const _UserTypeOption({required this.value, required this.label});
}

class _CountryOption {
  final String code;
  final String label;
  final String phoneCode;
  const _CountryOption({
    required this.code,
    required this.label,
    required this.phoneCode,
  });
}

/// Selectable card used for the "Who are you signing up as?" selector.
class _UserTypeCard extends StatelessWidget {
  final _UserTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height15,
          horizontal: Dimensions.width10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.primary : context.colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: Dimensions.iconSize16,
              color: selected
                  ? AppColors.primary
                  : context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Flexible(
              child: Text(
                option.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? AppColors.primary
                      : context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
