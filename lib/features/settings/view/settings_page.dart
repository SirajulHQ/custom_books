import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/view/custom_drawer.dart';
import 'package:flutter/material.dart';

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
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'settings'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'Settings',
              leadingType: AppBarLeadingType.menu,
              actions: [
                AppBarIconButton(
                  icon: Icons.power_settings_new_rounded,
                  color: Appcolors.warn,
                  onPressed: () {
                    appLog('🔴 Power button tapped', name: 'SettingsPage');
                    // TODO: Logout action
                  },
                ),
                SizedBox(width: Dimensions.width20),
              ],
            ),

            // Settings List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height15),

                  // ── Organization Section ────────────────────────────
                  _buildSettingsTile(
                    icon: Icons.business_rounded,
                    label: 'Organization Profile',
                    onTap: () {
                      appLog(
                        '🏢 Organization Profile tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Switch Organization',
                    onTap: () {
                      appLog(
                        '🔄 Switch Organization tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.people_outline_rounded,
                    label: 'Users',
                    onTap: () {
                      appLog('👥 Users tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.tune_rounded,
                    label: 'Preferences',
                    onTap: () {
                      appLog('🎛️ Preferences tapped', name: 'SettingsPage');
                    },
                  ),

                  _buildDivider(),

                  // ── Finance Section ─────────────────────────────────
                  _buildSettingsTile(
                    icon: Icons.currency_exchange_rounded,
                    label: 'Currencies',
                    onTap: () {
                      appLog('💱 Currencies tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.percent_rounded,
                    label: 'Taxes',
                    onTap: () {
                      appLog('💰 Taxes tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    label: 'PDF Template Customization',
                    onTap: () {
                      appLog(
                        '📄 PDF Template Customization tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.payment_rounded,
                    label: 'Online Payment Gateways',
                    onTap: () {
                      appLog(
                        '💳 Online Payment Gateways tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.mark_email_read_outlined,
                    label: 'Sender Email Preferences',
                    onTap: () {
                      appLog(
                        '✉️ Sender Email Preferences tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),

                  _buildDivider(),

                  // ── App Preferences Section ─────────────────────────
                  _buildSettingsTile(
                    icon: Icons.phone_android_rounded,
                    label: 'Opening Screen - Default',
                    onTap: () {
                      appLog('📱 Opening Screen tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.image_outlined,
                    label: 'Image upload resolution',
                    onTap: () {
                      appLog(
                        '🖼️ Image upload resolution tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.security_rounded,
                    label: 'Privacy & Security',
                    onTap: () {
                      appLog(
                        '🔒 Privacy & Security tapped',
                        name: 'SettingsPage',
                      );
                    },
                  ),

                  _buildDivider(),

                  // ── Support Section ─────────────────────────────────
                  _buildSettingsTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Feedback',
                    onTap: () {
                      appLog('💬 Feedback tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {
                      appLog('🔗 Share tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.star_border_rounded,
                    label: 'Rate App',
                    onTap: () {
                      appLog('⭐ Rate App tapped', name: 'SettingsPage');
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'About',
                    onTap: () {
                      appLog('ℹ️ About tapped', name: 'SettingsPage');
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height20,
          horizontal: Dimensions.width10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize24,
              color: context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Divider(color: context.colors.border, height: 1),
    );
  }
}
