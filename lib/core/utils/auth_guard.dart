// Authentication guard to protect routes and ensure user is logged in
// Automatically refreshes tokens if needed

import 'package:flutter/material.dart';
import 'package:custom_books/core/services/auth_service.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/auth/views/login_page.dart';

class AuthGuard {
  /// Check if user is authenticated and redirect to login if not
  /// Returns true if authenticated, false otherwise
  static Future<bool> checkAuth(BuildContext context) async {
    try {
      appLog('🔐 [AuthGuard] Checking authentication...');

      // Obtain a valid access token — this refreshes automatically when the
      // access token has expired but the refresh token is still good.
      final token = await AuthService.instance.getValidAccessToken();
      if (token != null) {
        appLog('✅ [AuthGuard] User is authenticated');
        return true;
      }

      appLog('🚫 [AuthGuard] No valid session, redirecting to login');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
      return false;
    } catch (e) {
      appLog('❌ [AuthGuard] Authentication check failed: $e');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
      return false;
    }
  }

  /// Ensure user is authenticated before executing an action
  /// If not authenticated, redirects to login
  static Future<T?> ensureAuth<T>(
    BuildContext context,
    Future<T> Function() action,
  ) async {
    final isAuthenticated = await checkAuth(context);
    if (isAuthenticated) {
      return await action();
    }
    return null;
  }

  /// Check if user is authenticated without redirecting
  /// Useful for conditional UI rendering
  static Future<bool> isAuthenticated() async {
    try {
      final token = await AuthService.instance.getValidAccessToken();
      return token != null;
    } catch (e) {
      appLog('❌ [AuthGuard] Authentication check failed: $e');
      return false;
    }
  }

  /// Get current user ID if authenticated
  static Future<String?> getCurrentUserId() async {
    try {
      // TODO: Implement when AuthService is ready
      return null;
    } catch (e) {
      appLog('❌ [AuthGuard] Failed to get user ID: $e');
      return null;
    }
  }

  /// Get current user email if authenticated
  static Future<String?> getCurrentUserEmail() async {
    try {
      // TODO: Implement when AuthService is ready
      return null;
    } catch (e) {
      appLog('❌ [AuthGuard] Failed to get user email: $e');
      return null;
    }
  }

  /// Logout the user and navigate to login page
  static Future<void> logout(BuildContext context) async {
    appLog('🔓 [AuthGuard] Logging out...');
    await AuthService.instance.clearSession();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

/// Widget wrapper that ensures authentication before showing content
class AuthGuardWidget extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;

  const AuthGuardWidget({super.key, required this.child, this.loadingWidget});

  @override
  State<AuthGuardWidget> createState() => _AuthGuardWidgetState();
}

class _AuthGuardWidgetState extends State<AuthGuardWidget> {
  bool _isChecking = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isAuth = await AuthGuard.checkAuth(context);
    if (mounted) {
      setState(() {
        _isAuthenticated = isAuth;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return widget.loadingWidget ??
          const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAuthenticated) {
      // Will be redirected by AuthGuard.checkAuth
      return const SizedBox.shrink();
    }

    return widget.child;
  }
}
