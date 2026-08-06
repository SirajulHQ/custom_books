// Authentication guard to protect routes and ensure user is logged in
// Automatically refreshes tokens if needed

import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/app_logger.dart';

// TODO: Implement AuthService when authentication is added
// import 'package:custom_books/core/service/auth_service.dart';
// import 'package:custom_books/features/auth/views/login_page.dart';

class AuthGuard {
  /// Check if user is authenticated and redirect to login if not
  /// Returns true if authenticated, false otherwise
  static Future<bool> checkAuth(BuildContext context) async {
    try {
      appLog('🔐 [AuthGuard] Checking authentication...');

      // TODO: Implement when AuthService is ready
      // final authService = AuthService();
      // await authService.initialize();

      // if (authService.isAuthenticated) {
      //   appLog('✅ [AuthGuard] User is authenticated');
      //   return true;
      // } else {
      //   appLog('❌ [AuthGuard] User is not authenticated, redirecting to login');
      //   if (context.mounted) {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (_) => const LoginPage()),
      //       (route) => false,
      //     );
      //   }
      //   return false;
      // }

      // Temporary: Always return true until auth is implemented
      appLog('⚠️ [AuthGuard] Auth not implemented yet, allowing access');
      return true;
    } catch (e) {
      appLog('❌ [AuthGuard] Authentication check failed: $e');

      // TODO: Uncomment when LoginPage is ready
      // if (context.mounted) {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (_) => const LoginPage()),
      //     (route) => false,
      //   );
      // }

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
      // TODO: Implement when AuthService is ready
      // final authService = AuthService();
      // await authService.initialize();
      // return authService.isAuthenticated;

      // Temporary: Always return true until auth is implemented
      return true;
    } catch (e) {
      appLog('❌ [AuthGuard] Authentication check failed: $e');
      return false;
    }
  }

  /// Get current user ID if authenticated
  static Future<String?> getCurrentUserId() async {
    try {
      // TODO: Implement when AuthService is ready
      // final authService = AuthService();
      // await authService.initialize();
      // return authService.currentUserId;

      // Temporary: Return null until auth is implemented
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
      // final authService = AuthService();
      // await authService.initialize();
      // return authService.currentUserEmail;

      // Temporary: Return null until auth is implemented
      return null;
    } catch (e) {
      appLog('❌ [AuthGuard] Failed to get user email: $e');
      return null;
    }
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
