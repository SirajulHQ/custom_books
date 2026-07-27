import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global controller that drives the app's light/dark theme.
///
/// It is a lightweight [ChangeNotifier]-free singleton built on top of a
/// [ValueNotifier] so any widget (e.g. the root [MaterialApp]) can rebuild
/// reactively when the theme mode changes. The [ValueNotifier] is what makes
/// the dark-mode toggle feel instant across the whole app.
///
/// The selected mode is persisted with [SharedPreferences] so it survives
/// app restarts. Call [load] once before `runApp` to restore it.
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
