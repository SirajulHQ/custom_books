import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/support_item_model.dart';
import 'package:flutter/material.dart';

class SupportContentWidget extends StatelessWidget {

  final SupportDataModel? data;

  const SupportContentWidget({super.key, this.data});

  static IconData _iconFor(String key) {
    switch (key) {
      case 'rocket':
      case 'rocket_launch':
        return Icons.rocket_launch_rounded;
      case 'bar_chart':
      case 'assessment':
        return Icons.assessment_rounded;
      case 'settings':
      case 'account_management':
        return Icons.settings_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  static const _categoryColors = [
    AppColors.primary,
    AppColors.ok,
    Color(0xFFF59E0B),
  ];

  @override
  Widget build(BuildContext context) {

    if (data == null) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: Dimensions.height30),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),

          Text(
            data!.heading,
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: context.colors.textPrimary,
            ),
          ),

          SizedBox(height: Dimensions.height10),

          Text(
            data!.subheading,
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textSecondary,
            ),
          ),

          SizedBox(height: Dimensions.height30),

          ...data!.categories.asMap().entries.map((entry) {
            final cat = entry.value;
            final color = _categoryColors[entry.key % _categoryColors.length];
            return Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height15),
              child: HelpCategoryCard(
                title: cat.title,
                description: cat.description,
                icon: _iconFor(cat.icon),
                color: color,
                topics: cat.items.map((i) => i.label).toList(),
              ),
            );
          }),

          SizedBox(height: Dimensions.height15),

          ContactSupportCard(
            heading: data!.contactHeading,
            buttonLabel: data!.contactButtonLabel,

            onTap: null,
          ),

          SizedBox(height: Dimensions.height30),
        ]),
      ),
    );
  }
}

class HelpCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> topics;

  const HelpCategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.5),
            blurRadius: Dimensions.radius15 * 0.53,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Dimensions.height45,
                height: Dimensions.height45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Icon(icon, color: color, size: Dimensions.iconSize24),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.9,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          ...topics.map(
            (topic) => Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: Dimensions.iconSize16,
                    color: color,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactSupportCard extends StatelessWidget {
  final String heading;
  final String buttonLabel;
  final VoidCallback? onTap;

  const ContactSupportCard({
    super.key,
    this.heading = 'Still need help?',
    this.buttonLabel = 'Contact Support',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: Dimensions.iconSize24 * 2,
            color: AppColors.primary,
          ),
          SizedBox(height: Dimensions.height15),
          Text(
            heading,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            'Contact our support team',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: Dimensions.radius15 * 0.53,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
