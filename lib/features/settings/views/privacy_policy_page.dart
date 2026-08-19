import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Privacy Policy',
              leadingType: AppBarLeadingType.back,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height15),
                  Text(
                    'Last updated: August 2026',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.8,
                      color: context.colors.textTertiary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  _buildSection(
                    context,
                    title: '1. Information We Collect',
                    content:
                        'Custom Books collects information you provide directly, including your name, email address, organization details, and financial data you enter into the application. This data is stored locally on your device and is not transmitted to external servers without your consent.',
                  ),
                  _buildSection(
                    context,
                    title: '2. How We Use Your Information',
                    content:
                        'We use the information to provide and maintain the Custom Books service, including generating invoices, managing customer records, tracking expenses, and producing financial reports. Your data is used solely for the functionality of this application.',
                  ),
                  _buildSection(
                    context,
                    title: '3. Data Storage & Security',
                    content:
                        'Your financial data is stored securely on your device using encrypted storage. We implement appropriate technical measures to protect your personal information against unauthorized access, alteration, or destruction.',
                  ),
                  _buildSection(
                    context,
                    title: '4. Third-Party Services',
                    content:
                        'Custom Books may use third-party services for PDF generation, email delivery, and payment processing. These services have their own privacy policies, and we encourage you to review them. We do not sell your personal data to third parties.',
                  ),
                  _buildSection(
                    context,
                    title: '5. Your Rights',
                    content:
                        'You have the right to access, update, or delete your personal information at any time through the application settings. You may also export your data or request a complete deletion of your account and associated data.',
                  ),
                  _buildSection(
                    context,
                    title: '6. Changes to This Policy',
                    content:
                        'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy within the application. Changes are effective immediately upon posting.',
                  ),
                  _buildSection(
                    context,
                    title: '7. Contact Us',
                    content:
                        'If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: sirajulhaq3154@gmail.com\nPhone: +91 96054 55758\n\nTech Geum Private Limited',
                  ),
                  SizedBox(height: Dimensions.height30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            content,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
