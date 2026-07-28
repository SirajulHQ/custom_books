import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._();

  /// Shared instance used across the app.
  static final ThemeController instance = ThemeController._();

  static const String _prefsKey = 'theme_mode';

  SharedPreferences? _prefs;

  /// Current theme mode. Listen to this to rebuild on change.
  final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  /// Whether the app is currently rendering in dark mode.
  bool get isDark => mode.value == ThemeMode.dark;

  /// Restores the saved theme mode. Call once during app startup.
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs?.getString(_prefsKey);
    mode.value = _decode(saved);
  }

  /// Flip between light and dark.
  void toggle() => _update(isDark ? ThemeMode.light : ThemeMode.dark);

  /// Explicitly set the theme mode.
  void setDark(bool value) => _update(value ? ThemeMode.dark : ThemeMode.light);

  void _update(ThemeMode value) {
    if (mode.value == value) return;
    mode.value = value;
    _prefs?.setString(_prefsKey, value.name);
  }

  ThemeMode _decode(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
