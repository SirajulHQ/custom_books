import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.9,
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: context.colors.textTertiary,
          fontSize: Dimensions.font16 * 0.9,
        ),
        prefixIcon:
            widget.prefixIcon ??
            Icon(
              Icons.search_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24,
            ),
        suffixIcon: _hasText && widget.showClearButton
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: context.colors.textSecondary,
                  size: Dimensions.iconSize24 * 0.9,
                ),
                onPressed: _clearText,
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: widget.fillColor ?? context.colors.surfaceLight,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? Dimensions.radius15,
          ),
          borderSide: BorderSide(color: widget.borderColor ?? context.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? Dimensions.radius15,
          ),
          borderSide: BorderSide(color: widget.borderColor ?? context.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? Dimensions.radius15,
          ),
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ListSearchField
// ---------------------------------------------------------------------------
/// Lightweight, stateless search field used on every list page.
/// Replicates the verbatim inline TextField pattern (same 3 OutlineInputBorder
/// variants, card fill, search prefix icon). Only [hintText], [controller],
/// and [onChanged] differ between pages.
///
/// [topPadding] defaults to [Dimensions.height10]; pass `0` for pages that
/// use a `_buildSearchField()` helper with no top gap.
class ListSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final double? topPadding;

  const ListSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        topPadding ?? Dimensions.height10,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        style: TextStyle(fontSize: Dimensions.font16 * 0.85),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: context.colors.textTertiary),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.textTertiary,
          ),
          filled: true,
          fillColor: context.colors.card,
          contentPadding: EdgeInsets.symmetric(
            vertical: Dimensions.height10,
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
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
