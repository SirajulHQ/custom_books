import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/settings/views/users/edit_user_page.dart';
import 'package:custom_books/features/settings/views/users/invite_user_page.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<_UserItem> _users = [
    _UserItem(
      name: 'Sirajul Haq',
      email: 'sirajulhaq344@gmail.com',
      role: 'Admin',
      status: 'ACTIVE',
    ),
  ];

  @override
  void initState() {
    super.initState();
    appLog('👥 UsersPage initialized', name: 'UsersPage');
  }

  void _inviteUser() {
    appLog('➕ Invite user tapped', name: 'UsersPage');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InviteUserPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      floatingActionButton: CustomAddButton(
        onPressed: _inviteUser,
        backgroundColor: context.colors.textPrimary,
        foregroundColor: context.colors.background,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Users',
              leadingType: AppBarLeadingType.back,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final user = _users[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        appLog('✏️ Edit user: ${user.name}', name: 'UsersPage');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditUserPage(
                              name: user.name,
                              email: user.email,
                              role: user.role,
                            ),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10 / 2,
                      ),
                      leading: CircleAvatar(
                        radius: Dimensions.radius20,
                        backgroundColor: context.colors.surfaceLight,
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: context.colors.textSecondary,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.8,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          Text(
                            user.role,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: context.colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        user.status,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.75,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.ok,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: context.colors.border,
                      indent: Dimensions.width20,
                      endIndent: Dimensions.width20,
                    ),
                  ],
                );
              }, childCount: _users.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserItem {
  final String name;
  final String email;
  final String role;
  final String status;

  _UserItem({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });
}
