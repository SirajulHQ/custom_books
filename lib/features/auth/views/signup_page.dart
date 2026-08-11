import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/form_validators.dart';
import 'package:custom_books/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    appLog('📝 Sign up tapped', name: 'SignupPage');
    appLog(
      '   Name: ${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      name: 'SignupPage',
    );
    appLog('   Email: ${_emailController.text.trim()}', name: 'SignupPage');
    appLog('   Phone: ${_phoneController.text.trim()}', name: 'SignupPage');

    // TODO: Implement actual signup API call
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate to login page after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

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

                  // Logo / App icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF42A5F5),
                          Color(0xFF1565C0),
                          Color(0xFF0D47A1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

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

                  // First Name & Last Name row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          textCapitalization: TextCapitalization.words,
                          validator: FormValidators.validateFirstName,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: Dimensions.font16,
                          ),
                          decoration: _inputDecoration(
                            context,
                            label: 'First Name',
                            icon: Icons.person_outlined,
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (v) => FormValidators.validateLastName(
                            v,
                            isRequired: false,
                          ),
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: Dimensions.font16,
                          ),
                          decoration: _inputDecoration(
                            context,
                            label: 'Last Name',
                            icon: Icons.person_outlined,
                          ),
                        ),
                      ),
                    ],
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
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                  ),

                  SizedBox(height: Dimensions.height15),

                  // Phone field
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
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
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

                  // Confirm Password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: _inputDecoration(
                      context,
                      label: 'Confirm Password',
                      icon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: context.colors.textSecondary,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height30),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Appcolors.primary.withValues(
                          alpha: 0.6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
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
                            color: Appcolors.primary,
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
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.colors.textSecondary),
      prefixIcon: Icon(icon, color: context.colors.textSecondary),
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
        borderSide: const BorderSide(color: Appcolors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: const BorderSide(color: Appcolors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: const BorderSide(color: Appcolors.error, width: 1.5),
      ),
    );
  }
}
