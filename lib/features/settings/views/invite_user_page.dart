import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class InviteUserPage extends StatefulWidget {
  const InviteUserPage({super.key});

  @override
  State<InviteUserPage> createState() => _InviteUserPageState();
}

class _InviteUserPageState extends State<InviteUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedRole = 'Staff (Assigned Customers Only)';

  static const List<Map<String, String>> _roles = [
    {
      'name': 'Admin',
      'description':
          'Full access to all modules, transactions, settings, and data.',
    },
    {
      'name': 'Staff (Assigned Customers Only)',
      'description':
          'Access to all modules, transactions and data of assigned customers and all vendors except banking, reports, settings and accountant.',
    },
    {
      'name': 'Staff (All Customers)',
      'description':
          'Access to all modules, transactions and data of all customers and vendors except banking, reports, settings and accountant.',
    },
    {
      'name': 'Time Tracking Only',
      'description': 'Access only to time tracking and project modules.',
    },
  ];

  @override
  void initState() {
    super.initState();
    appLog('📨 InviteUserPage initialized', name: 'InviteUser');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _send() {
    appLog('📤 Send invite tapped', name: 'InviteUser');
    // TODO: Implement invite logic
    Navigator.pop(context);
  }

  Future<void> _selectRole() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Select Role',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _roles
                    .map(
                      (role) => ListTile(
                        title: Text(
                          role['name']!,
                          style: TextStyle(
                            color: role['name'] == _selectedRole
                                ? Appcolors.primary
                                : context.colors.textPrimary,
                            fontWeight: role['name'] == _selectedRole
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          role['description']!,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                        trailing: role['name'] == _selectedRole
                            ? Icon(
                                Icons.check_rounded,
                                color: Appcolors.primary,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, role['name']),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _selectedRole = selected);
    }
  }

  String _getRoleDescription() {
    final role = _roles.firstWhere(
      (r) => r['name'] == _selectedRole,
      orElse: () => _roles.first,
    );
    return role['description'] ?? '';
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
            CustomSliverAppBar(
              title: 'Invite User',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SEND', onPressed: _send),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: Column(
                  children: [
                    // Info Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimensions.width15),
                      decoration: BoxDecoration(
                        color: Appcolors.info.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: Appcolors.info.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: Dimensions.iconSize24,
                            color: Appcolors.info,
                          ),
                          SizedBox(width: Dimensions.width10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Want to create custom roles with restricted access? Visit our web application https://www.zoho.com/books on a PC or laptop to explore more options.',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.8,
                                    color: context.colors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                Text(
                                  'Learn More ›',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.8,
                                    color: Appcolors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),

                    // User Form
                    FormCard(
                      children: [
                        const RequiredLabel(text: 'Name'),
                        SizedBox(height: Dimensions.height10 / 2),
                        TextField(
                          controller: _nameController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(),
                        ),
                        SizedBox(height: Dimensions.height20),

                        const RequiredLabel(text: 'Email Address'),
                        SizedBox(height: Dimensions.height10 / 2),
                        TextField(
                          controller: _emailController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: Dimensions.height20),

                        Text('Role', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _selectedRole,
                          hint: 'Select Role',
                          onTap: _selectRole,
                        ),
                        SizedBox(height: Dimensions.height10),
                        Text(
                          _getRoleDescription(),
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.75,
                            color: context.colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _underlineDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Appcolors.primary),
      ),
    );
  }

  Widget _selectorField({
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  color: value == null
                      ? context.colors.textTertiary
                      : context.colors.textPrimary,
                  fontWeight: value == null
                      ? FontWeight.normal
                      : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: Dimensions.iconSize24,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
