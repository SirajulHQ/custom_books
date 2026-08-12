import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/privacy_policy_page.dart';
import 'package:custom_books/features/settings/views/terms_of_service_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _appLockEnabled = false;
  bool _biometricEnabled = false;
  bool _autoLockOnExit = true;
  bool _hideAmounts = false;
  String _autoLockDuration = 'Immediately';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _appLockEnabled = prefs.getBool('privacy_app_lock') ?? false;
        _biometricEnabled = prefs.getBool('privacy_biometric') ?? false;
        _autoLockOnExit = prefs.getBool('privacy_auto_lock_exit') ?? true;
        _hideAmounts = prefs.getBool('privacy_hide_amounts') ?? false;
        _autoLockDuration =
            prefs.getString('privacy_auto_lock_duration') ?? 'Immediately';
      });
    }
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Privacy & Security',
              leadingType: AppBarLeadingType.back,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height15),

                  // ── App Lock Section ──────────────────────────────
                  _buildSectionHeader('APP LOCK'),
                  SizedBox(height: Dimensions.height10),

                  _buildSwitchTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Enable App Lock',
                    subtitle: 'Require authentication to open the app',
                    value: _appLockEnabled,
                    onChanged: (val) {
                      appLog('🔐 App Lock: $val', name: 'PrivacySecurity');
                      setState(() => _appLockEnabled = val);
                      _saveBool('privacy_app_lock', val);
                    },
                  ),

                  if (_appLockEnabled) ...[
                    _buildSwitchTile(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Unlock',
                      subtitle: 'Use fingerprint or face to unlock',
                      value: _biometricEnabled,
                      onChanged: (val) {
                        appLog('👆 Biometric: $val', name: 'PrivacySecurity');
                        setState(() => _biometricEnabled = val);
                        _saveBool('privacy_biometric', val);
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.exit_to_app_rounded,
                      title: 'Lock on App Exit',
                      subtitle: 'Automatically lock when you leave the app',
                      value: _autoLockOnExit,
                      onChanged: (val) {
                        appLog(
                          '🔒 Lock on exit: $val',
                          name: 'PrivacySecurity',
                        );
                        setState(() => _autoLockOnExit = val);
                        _saveBool('privacy_auto_lock_exit', val);
                      },
                    ),
                    _buildDropdownTile(
                      icon: Icons.timer_outlined,
                      title: 'Auto-Lock After',
                      value: _autoLockDuration,
                      options: [
                        'Immediately',
                        '30 seconds',
                        '1 minute',
                        '5 minutes',
                      ],
                      onChanged: (val) {
                        appLog(
                          '⏱️ Auto-lock duration: $val',
                          name: 'PrivacySecurity',
                        );
                        setState(() => _autoLockDuration = val!);
                        _saveString('privacy_auto_lock_duration', val!);
                      },
                    ),
                  ],

                  SizedBox(height: Dimensions.height20),
                  Divider(color: context.colors.border),
                  SizedBox(height: Dimensions.height15),

                  // ── Data Privacy Section ──────────────────────────
                  _buildSectionHeader('DATA PRIVACY'),
                  SizedBox(height: Dimensions.height10),

                  _buildSwitchTile(
                    icon: Icons.visibility_off_outlined,
                    title: 'Hide Amounts on Dashboard',
                    subtitle: 'Mask financial figures until you tap to reveal',
                    value: _hideAmounts,
                    onChanged: (val) {
                      appLog('👁️ Hide amounts: $val', name: 'PrivacySecurity');
                      setState(() => _hideAmounts = val);
                      _saveBool('privacy_hide_amounts', val);
                    },
                  ),

                  SizedBox(height: Dimensions.height20),
                  Divider(color: context.colors.border),
                  SizedBox(height: Dimensions.height15),

                  // ── Info Section ──────────────────────────────────
                  _buildSectionHeader('DATA & STORAGE'),
                  SizedBox(height: Dimensions.height10),

                  _buildInfoTile(
                    icon: Icons.storage_rounded,
                    title: 'Clear Cache',
                    subtitle: 'Free up space by clearing temporary files',
                    onTap: () {
                      appLog('🗑️ Clear cache tapped', name: 'PrivacySecurity');
                      ToastificationHelper.showSuccess(
                        context,
                        'Cache cleared successfully',
                      );
                    },
                  ),
                  _buildInfoTile(
                    icon: Icons.policy_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {
                      appLog(
                        '📋 Privacy Policy tapped',
                        name: 'PrivacySecurity',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  _buildInfoTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    onTap: () {
                      appLog(
                        '📋 Terms of Service tapped',
                        name: 'PrivacySecurity',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsOfServicePage(),
                        ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.7,
        fontWeight: FontWeight.w700,
        color: context.colors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSize24, color: Appcolors.primary),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.72,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Appcolors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSize24, color: Appcolors.primary),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.colors.textSecondary,
              ),
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: Appcolors.primary,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: context.colors.card,
              items: options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Dimensions.width15),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: Dimensions.iconSize24,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.9,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
