import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/settings_tile.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:custom_books/features/settings/views/organization_profile_page.dart';
import 'package:custom_books/features/settings/views/switch_organization_page.dart';
import 'package:custom_books/features/settings/views/users/users_page.dart';
import 'package:custom_books/features/settings/views/preferences_page.dart';
import 'package:custom_books/features/settings/views/currencies/currencies_page.dart';
import 'package:custom_books/features/settings/views/taxes/taxes_page.dart';
import 'package:custom_books/features/settings/views/templates/templates_page.dart';
import 'package:custom_books/features/settings/views/payment_gateways/payment_gateways_page.dart';
import 'package:custom_books/features/settings/views/email_preferences/sender_email_preferences_page.dart';
import 'package:custom_books/features/settings/views/opening_screen_page.dart';
import 'package:custom_books/features/settings/views/image_resolution_page.dart';
import 'package:custom_books/features/settings/views/privacy_security_page.dart';
import 'package:custom_books/features/settings/views/feedback_page.dart';
import 'package:custom_books/features/settings/views/about_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    appLog('⚙️ SettingsPage initialized', name: 'SettingsPage');
  }

  @override
  Widget build(BuildContext context) {
    appLog('🏗️ Building SettingsPage', name: 'SettingsPage');
    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'settings'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            const CustomSliverAppBar(
              title: 'Settings',
              leadingType: AppBarLeadingType.menu,
            ),

            // Settings List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height15),

                  // ── Organization Section ────────────────────────────
                  SettingsTile(
                    icon: Icons.business_rounded,
                    label: 'Organization Profile',
                    onTap: () {
                      appLog(
                        '🏢 Organization Profile tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganizationProfilePage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Switch Organization',
                    onTap: () {
                      appLog(
                        '🔄 Switch Organization tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SwitchOrganizationPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.people_outline_rounded,
                    label: 'Users',
                    onTap: () {
                      appLog('👥 Users tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.tune_rounded,
                    label: 'Preferences',
                    onTap: () {
                      appLog('🎛️ Preferences tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreferencesPage(),
                        ),
                      );
                    },
                  ),

                  _buildDivider(),

                  // ── Finance Section ─────────────────────────────────
                  SettingsTile(
                    icon: Icons.currency_exchange_rounded,
                    label: 'Currencies',
                    onTap: () {
                      appLog('💱 Currencies tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CurrenciesPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.percent_rounded,
                    label: 'Taxes',
                    onTap: () {
                      appLog('💰 Taxes tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TaxesPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.description_outlined,
                    label: 'PDF Template Customization',
                    onTap: () {
                      appLog(
                        '📄 PDF Template Customization tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TemplatesPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.payment_rounded,
                    label: 'Online Payment Gateways',
                    onTap: () {
                      appLog(
                        '💳 Online Payment Gateways tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentGatewaysPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.mark_email_read_outlined,
                    label: 'Sender Email Preferences',
                    onTap: () {
                      appLog(
                        '✉️ Sender Email Preferences tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SenderEmailPreferencesPage(),
                        ),
                      );
                    },
                  ),

                  _buildDivider(),

                  // ── App Preferences Section ─────────────────────────
                  SettingsTile(
                    icon: Icons.phone_android_rounded,
                    label: 'Opening Screen - Default',
                    onTap: () {
                      appLog('📱 Opening Screen tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OpeningScreenPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.image_outlined,
                    label: 'Image upload resolution',
                    onTap: () {
                      appLog(
                        '🖼️ Image upload resolution tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ImageResolutionPage(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.security_rounded,
                    label: 'Privacy & Security',
                    onTap: () {
                      appLog(
                        '🔒 Privacy & Security tapped',
                        name: 'SettingsPage',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacySecurityPage(),
                        ),
                      );
                    },
                  ),

                  _buildDivider(),

                  // ── Support Section ─────────────────────────────────
                  SettingsTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Feedback',
                    onTap: () {
                      appLog('💬 Feedback tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeedbackPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {
                      appLog('🔗 Share tapped', name: 'SettingsPage');
                      _shareApp();
                    },
                  ),
                  SettingsTile(
                    icon: Icons.star_border_rounded,
                    label: 'Rate App',
                    onTap: () {
                      appLog('⭐ Rate App tapped', name: 'SettingsPage');
                      _rateApp();
                    },
                  ),
                  SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'About',
                    onTap: () {
                      appLog('ℹ️ About tapped', name: 'SettingsPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
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

  void _shareApp() {
    const String message =
        'Check out Custom Books - a simple and powerful accounting app for your business!\n\nhttps://play.google.com/store/apps';
    launchUrl(
      Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _rateApp() {
    launchUrl(
      Uri.parse('market://details?id=com.example.custom_books'),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Divider(color: context.colors.border, height: 1),
    );
  }
}
