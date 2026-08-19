import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/form_validators.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitResetRequest() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    appLog(
      '📧 Password reset requested for: ${_emailController.text.trim()}',
      name: 'ForgotPasswordPage',
    );

    // TODO: Implement actual password reset API call
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.textPrimary,
            size: Dimensions.iconSize20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
            child: _emailSent
                ? _buildSuccessView(context)
                : _buildFormView(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: Dimensions.height80,
            height: Dimensions.height80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              color: AppColors.primary,
              size: Dimensions.iconSize40,
            ),
          ),

          SizedBox(height: Dimensions.height30),

          // Title
          Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              color: context.colors.textSecondary,
              height: 1.4,
            ),
          ),

          SizedBox(height: Dimensions.height45),

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: Dimensions.font16,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: context.colors.textSecondary),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.colors.textSecondary,
              ),
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
            ),
          ),

          SizedBox(height: Dimensions.height30),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: Dimensions.height52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitResetRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: Dimensions.iconSize22,
                      height: Dimensions.iconSize22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: Dimensions.height80,
          height: Dimensions.height80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.success,
            size: Dimensions.iconSize40,
          ),
        ),

        SizedBox(height: Dimensions.height30),

        // Title
        Text(
          'Check Your Email',
          style: TextStyle(
            fontSize: Dimensions.font26,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Text(
          'We\'ve sent a password reset link to',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 2),
        Text(
          _emailController.text.trim(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),

        SizedBox(height: Dimensions.height45),

        // Back to Sign In button
        SizedBox(
          width: double.infinity,
          height: Dimensions.height52,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              elevation: 0,
            ),
            child: Text(
              'Back to Sign In',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: Dimensions.height20),

        // Resend option
        GestureDetector(
          onTap: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            'Didn\'t receive the email? Try again',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
