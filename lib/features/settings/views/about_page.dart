import 'dart:io' show Platform;

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/privacy_policy_page.dart';
import 'package:custom_books/features/settings/views/terms_of_service_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'About',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height30),

                    // App Icon
                    Container(
                      width: Dimensions.height45 * 2,
                      height: Dimensions.height45 * 2,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: Dimensions.height45,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // App Name
                    Text(
                      'Custom Books',
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 1.2,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      'Version 1.0.0 (Build 1)',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textSecondary,
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Description
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimensions.width20),
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Text(
                        'Custom Books is a comprehensive accounting and invoicing app designed for small businesses. Manage customers, vendors, invoices, bills, expenses, and more — all in one place.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Info tiles
                    _buildInfoRow(
                      context,
                      icon: Icons.code_rounded,
                      label: 'Framework',
                      value: 'Flutter',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.devices_rounded,
                      label: 'Platform',
                      value: Platform.isIOS ? 'iOS' : 'Android',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.update_rounded,
                      label: 'Last Updated',
                      value: 'August 2026',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.business_rounded,
                      label: 'Developer',
                      value: 'Tech Geum Private Limited',
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Support Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimensions.width15),
                      decoration: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUPPORT',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.7,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textTertiary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          InkWell(
                            onTap: () => launchUrl(
                              Uri.parse('tel:+919605455758'),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: Dimensions.iconSize24 - 4,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: Dimensions.width15),
                                Text(
                                  '+91 96054 55758',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height15),
                          InkWell(
                            onTap: () => launchUrl(
                              Uri.parse('mailto:sirajulhaq3154@gmail.com'),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: Dimensions.iconSize24 - 4,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: Dimensions.width15),
                                Text(
                                  'sirajulhaq3154@gmail.com',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Footer links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLinkButton(context, 'Privacy Policy', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyPage(),
                            ),
                          );
                        }),
                        Container(
                          width: 1,
                          height: Dimensions.font16,
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                          ),
                          color: context.colors.border,
                        ),
                        _buildLinkButton(context, 'Terms of Service', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsOfServicePage(),
                            ),
                          );
                        }),
                      ],
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Copyright
                    Text(
                      '© 2026 Tech Geum Private Limited. All rights reserved.',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.7,
                        color: context.colors.textTertiary,
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height15,
      ),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSize24, color: AppColors.primary),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.8,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
