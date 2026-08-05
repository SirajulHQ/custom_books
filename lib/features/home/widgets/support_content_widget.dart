import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContentWidget extends StatelessWidget {
  const SupportContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(height: Dimensions.height15),

          Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: context.colors.textPrimary,
            ),
          ),

          SizedBox(height: Dimensions.height10),

          Text(
            'Find answers to common questions or contact support',
            style: TextStyle(
              fontSize: Dimensions.font16,
              color: context.colors.textSecondary,
            ),
          ),

          SizedBox(height: Dimensions.height30),

          HelpCategoryCard(
            title: 'Getting Started',
            description: 'Learn the basics of using Own Store',
            icon: Icons.rocket_launch_rounded,
            color: Appcolors.primary,
            topics: const [
              'Creating your first invoice',
              'Adding customers and vendors',
              'Setting up payment methods',
              'Understanding the dashboard',
            ],
          ),

          SizedBox(height: Dimensions.height15),

          HelpCategoryCard(
            title: 'Financial Reports',
            description: 'Generate and understand reports',
            icon: Icons.assessment_rounded,
            color: Appcolors.ok,
            topics: const [
              'Cash flow statements',
              'Income and expense reports',
              'Tax preparation reports',
              'Custom report builder',
            ],
          ),

          SizedBox(height: Dimensions.height15),

          HelpCategoryCard(
            title: 'Account Management',
            description: 'Manage your account settings',
            icon: Icons.settings_rounded,
            color: const Color(0xFFF59E0B),
            topics: const [
              'Update profile information',
              'Change password',
              'Notification preferences',
              'Subscription and billing',
            ],
          ),

          SizedBox(height: Dimensions.height30),

          ContactSupportCard(
            onTap: () {
              launchUrl(Uri.parse('mailto:support@yourcompany.com'));
            },
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
            blurRadius: 8,
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
  final VoidCallback? onTap;

  const ContactSupportCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Appcolors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: Appcolors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: Dimensions.iconSize24 * 2,
            color: Appcolors.primary,
          ),
          SizedBox(height: Dimensions.height15),
          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w800,
              color: Appcolors.primary,
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
                color: Appcolors.primary,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Contact Support',
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
