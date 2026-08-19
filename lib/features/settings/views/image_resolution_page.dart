import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageResolutionPage extends StatefulWidget {
  const ImageResolutionPage({super.key});

  @override
  State<ImageResolutionPage> createState() => _ImageResolutionPageState();
}

class _ImageResolutionPageState extends State<ImageResolutionPage> {
  static const String _prefsKey = 'image_resolution';

  String _selected = 'Medium (1024px)';

  final List<_ResolutionOption> _options = [
    _ResolutionOption(
      label: 'Low (512px)',
      description: 'Smaller file size, faster uploads. Best for documents.',
    ),
    _ResolutionOption(
      label: 'Medium (1024px)',
      description: 'Good balance between quality and file size. Recommended.',
      isRecommended: true,
    ),
    _ResolutionOption(
      label: 'High (2048px)',
      description: 'Higher quality images. Larger file sizes.',
    ),
    _ResolutionOption(
      label: 'Original',
      description: 'No compression. Uses the full original resolution.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && mounted) {
      setState(() => _selected = saved);
    }
  }

  Future<void> _savePreference(String value) async {
    appLog('🖼️ Image resolution changed to: $value', name: 'ImageResolution');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value);
    if (mounted) {
      setState(() => _selected = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Image Upload Resolution',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height15,
                  Dimensions.width20,
                  Dimensions.height20,
                ),
                child: Text(
                  'Choose the resolution for images uploaded with receipts, expenses, and documents.',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final option = _options[index];
                  final isSelected = option.label == _selected;
                  return Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      onTap: () => _savePreference(option.label),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.width15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : context.colors.card,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : context.colors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: Dimensions.font16 * 0.9,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.primary
                                          : context.colors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height10 / 3),
                                  Text.rich(
                                    TextSpan(
                                      text: option.isRecommended
                                          ? 'Good balance between quality and file size. '
                                          : option.description,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.75,
                                        color: context.colors.textSecondary,
                                      ),
                                      children: option.isRecommended
                                          ? [
                                              TextSpan(
                                                text: 'Recommended.',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.width10,
                                ),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  size: Dimensions.iconSize24,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: _options.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.width15),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.info,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: Text(
                          'Higher resolution images provide better quality but use more storage and data.',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.75,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolutionOption {
  final String label;
  final String description;
  final bool isRecommended;

  const _ResolutionOption({
    required this.label,
    required this.description,
    this.isRecommended = false,
  });
}
