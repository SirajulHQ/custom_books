import 'dart:convert';

import 'package:custom_books/core/services/token_storage.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/features/auth/viewmodels/token_refresh_viewmodel.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final TokenStorage _storage = TokenStorage.instance;
  final TokenRefreshViewModel _refreshVm = TokenRefreshViewModel();

  String? _accessToken;
  String? _refreshToken;

  /// Refresh the access token when it has less than this much life left, so
  /// an in-flight request doesn't fail on a token that expires mid-flight.
  static const Duration _expiryLeeway = Duration(seconds: 30);

  /// Guards against firing multiple refresh calls at once; concurrent callers
  /// await the same in-flight refresh instead.
  Future<bool>? _refreshInFlight;

  /// Loads persisted tokens into memory. Call once during app startup.
  Future<void> initialize() async {
    _accessToken = await _storage.readAccessToken();
    _refreshToken = await _storage.readRefreshToken();
    appLog(
      '🔐 AuthService initialized (hasSession: ${_refreshToken != null})',
      name: 'AuthService',
    );
  }

  /// Stores the token pair returned by login and keeps them in memory.
  Future<void> saveSession({
    required String access,
    required String refresh,
  }) async {
    _accessToken = access;
    _refreshToken = refresh;
    await _storage.saveTokens(access: access, refresh: refresh);
  }

  /// Clears all tokens from memory and storage (logout).
  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.clear();
  }

  bool get hasSession => _refreshToken != null && _refreshToken!.isNotEmpty;

  Future<String?> getValidAccessToken() async {
    if (!hasSession) return null;

    if (_accessToken != null && !_isExpired(_accessToken!)) {
      return _accessToken;
    }

    appLog(
      '♻️ Access token missing/expired — refreshing',
      name: 'AuthService',
    );
    final refreshed = await _refresh();
    return refreshed ? _accessToken : null;
  }

  /// Forces a refresh regardless of current expiry. Useful after a 401.
  Future<bool> refreshAccessToken() => _refresh();

  Future<bool> _refresh() {
    // Coalesce concurrent refreshes into a single network call.
    return _refreshInFlight ??= _doRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<bool> _doRefresh() async {
    final refresh = _refreshToken;
    if (refresh == null || refresh.isEmpty) return false;

    final resp = await _refreshVm.refresh(refreshToken: refresh);
    final int? status = resp?['_statusCode'] as int?;
    final String? newAccess = resp?['access'] as String?;

    final bool ok =
        resp != null &&
        status != null &&
        status >= 200 &&
        status < 300 &&
        newAccess != null;

    if (!ok) {
      appLog(
        '⚠️ Refresh failed (status: $status) — session expired',
        name: 'AuthService',
      );
      // A dead refresh token means the session is over; clear it so the app
      // routes to login instead of retrying forever.
      await clearSession();
      return false;
    }

    _accessToken = newAccess;
    await _storage.saveAccessToken(newAccess);

    // SimpleJWT with ROTATE_REFRESH_TOKENS returns a new refresh token too.
    final String? newRefresh = resp['refresh'] as String?;
    if (newRefresh != null && newRefresh.isNotEmpty) {
      _refreshToken = newRefresh;
      await _storage.saveTokens(access: newAccess, refresh: newRefresh);
    }

    appLog('✅ Access token refreshed', name: 'AuthService');
    return true;
  }

  /// Decodes a JWT and returns true if its `exp` claim is in the past
  /// (within [_expiryLeeway]). Malformed tokens are treated as expired.
  bool _isExpired(String jwt) {
    final exp = _expiry(jwt);
    if (exp == null) return true;
    return DateTime.now().toUtc().add(_expiryLeeway).isAfter(exp);
  }

  DateTime? _expiry(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final exp = map['exp'];
      if (exp is! int) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    } catch (e) {
      appLog('⚠️ Could not decode JWT exp: $e', name: 'AuthService');
      return null;
    }
  }
}
