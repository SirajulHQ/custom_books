import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class SwitchOrganizationPage extends StatefulWidget {
  const SwitchOrganizationPage({super.key});

  @override
  State<SwitchOrganizationPage> createState() => _SwitchOrganizationPageState();
}

class _SwitchOrganizationPageState extends State<SwitchOrganizationPage> {
  int _selectedIndex = 0;

  final List<String> _organizations = ['Own Store', 'Techgeum Books'];

  @override
  void initState() {
    super.initState();
    appLog('🔄 SwitchOrganizationPage initialized', name: 'SwitchOrganization');
  }

  void _selectOrganization(int index) {
    appLog(
      '🏢 Selected organization: ${_organizations[index]}',
      name: 'SwitchOrganization',
    );
    setState(() => _selectedIndex = index);

    // TODO: Call API to switch organization context
    ToastificationHelper.showSuccess(
      context,
      'Switched to ${_organizations[index]}',
    );
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
              title: 'Organizations',
              leadingType: AppBarLeadingType.back,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final isSelected = index == _selectedIndex;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10 / 2,
                      ),
                      title: Text(
                        _organizations[index],
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: context.colors.textPrimary,
                              size: Dimensions.iconSize24,
                            )
                          : null,
                      onTap: () => _selectOrganization(index),
                    ),
                    Divider(
                      height: 1,
                      color: context.colors.border,
                      indent: Dimensions.width20,
                      endIndent: Dimensions.width20,
                    ),
                  ],
                );
              }, childCount: _organizations.length),
            ),
          ],
        ),
      ),
    );
  }
}
