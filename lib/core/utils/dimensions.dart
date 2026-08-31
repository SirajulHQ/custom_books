import 'package:flutter/material.dart';

/// Central design-token source.
///
/// Tokens are calibrated against a reference device of ~844pt height
/// (iPhone 12/13/14 class). To stay iPhone-ready across the whole lineup
/// (and a future iPad/universal build) the values that drive typography,
/// icons, radii and spacing are derived from a *clamped* dimension:
///
///  * Mainstream iPhones (SE bumped slightly, up to Pro Max) render
///    identically to the original design.
///  * Very small phones (iPhone SE) get a gentle floor so text stays legible.
///  * Large canvases (iPad / foldables) get a ceiling so nothing balloons.
///
/// Raw [screenHeight] / [screenWidth] remain the true, unclamped values for
/// callers that intentionally size against the real screen (charts, etc.).
class Dimensions {
  const Dimensions._();

  // ── Clamp bounds (logical points) ─────────────────────────────────────
  // Height range spans iPhone SE (667) floored to 700 up to a tablet ceiling.
  static const double _minRefHeight = 700.0;
  static const double _maxRefHeight = 1000.0;
  // Width ceiling keeps horizontal spacing sane on tablets; every iPhone
  // (<= ~440pt wide) stays untouched.
  static const double _maxRefWidth = 480.0;

  // ── Raw screen size ────────────────────────────────────────────────────
  static late double screenHeight;
  static late double screenWidth;

  // ── Clamped values that back the design tokens ─────────────────────────
  static late double _h;
  static late double _w;

  // ── Safe-area insets (notch / Dynamic Island / home indicator) ─────────
  static late double topInset;
  static late double bottomInset;

  /// On-screen keyboard height (view insets). Add to bottom padding of
  /// scrollables inside bottom sheets so fields stay visible.
  static late double keyboardInset;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    screenHeight = size.height;
    screenWidth = size.width;

    _h = size.height.clamp(_minRefHeight, _maxRefHeight);
    _w = size.width.clamp(0.0, _maxRefWidth);

    topInset = mediaQuery.padding.top;
    bottomInset = mediaQuery.padding.bottom;
    keyboardInset = mediaQuery.viewInsets.bottom;
  }

  // Heights
  static double get height10 => _h / 84.4;
  static double get height15 => _h / 56.27;
  static double get height20 => _h / 42.2;
  static double get height30 => _h / 28.13;
  static double get height45 => _h / 18.76;
  static double get height52 => _h / 16.23;
  static double get height80 => _h / 10.55;
  static double get height90 => _h / 9.38;

  // Widths
  static double get width10 => _w / 84.4;
  static double get width15 => _w / 56.27;
  static double get width20 => _w / 42.2;
  static double get width30 => _w / 28.13;

  // Font sizes
  static double get font16 => _h / 52.75;
  static double get font20 => _h / 42.2;
  static double get font26 => _h / 32.46;

  // Radius
  static double get radius15 => _h / 56.27;
  static double get radius20 => _h / 42.2;
  static double get radius30 => _h / 28.13;

  // Icon sizes
  static double get iconSize16 => _h / 52.75;
  static double get iconSize20 => _h / 42.2;
  static double get iconSize22 => _h / 38.36;
  static double get iconSize24 => _h / 35.17;
  static double get iconSize36 => _h / 23.44;
  static double get iconSize40 => _h / 21.1;

  // ── Safe-area helpers ──────────────────────────────────────────────────

  /// Bottom padding for scrollables whose content would otherwise sit under
  /// the home indicator. Use for list/scroll views without a bottom bar.
  static double get bottomSafeSpace => bottomInset + height20;

  /// Bottom padding for scroll views on pages that carry a floating action
  /// button. Clears the FAB *and* the home indicator so the last item and
  /// the button never overlap.
  static double get listBottomSpace => bottomInset + height80;
}
