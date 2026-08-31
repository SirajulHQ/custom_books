import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/settings/views/email_preferences/new_sender_page.dart';
import 'package:custom_books/features/settings/views/email_preferences/email_delivery_method_page.dart';
import 'package:flutter/material.dart';

class SenderEmailPreferencesPage extends StatefulWidget {
  const SenderEmailPreferencesPage({super.key});

  @override
  State<SenderEmailPreferencesPage> createState() =>
      _SenderEmailPreferencesPageState();
}

class _SenderEmailPreferencesPageState
    extends State<SenderEmailPreferencesPage> {
  bool _publicDomainsExpanded = false;

  final List<_SenderItem> _senders = [
    _SenderItem(
      name: 'Sirajul Haq',
      email: 'sirajulhaq344@gmail.com',
      isPrimary: true,
    ),
    _SenderItem(
      name: 'Tech Geum Support',
      email: 'support@techgeum.com',
      isPrimary: false,
    ),
    _SenderItem(
      name: 'Billing Department',
      email: 'billing@techgeum.com',
      isPrimary: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    appLog('✉️ SenderEmailPreferencesPage initialized', name: 'SenderEmail');
  }

  void _addNewSender() {
    appLog('➕ New Sender tapped', name: 'SenderEmail');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewSenderPage()),
    );
  }

  void _showSenderOptions(_SenderItem sender) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star_outline_rounded),
              title: const Text('Set as Primary'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.warn),
              title: Text('Delete', style: TextStyle(color: AppColors.warn)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDeliveryMethod() {
    appLog('📧 Choose How to Send Emails tapped', name: 'SenderEmail');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmailDeliveryMethodPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      floatingActionButton: CustomAddButton(onPressed: _addNewSender),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CustomSliverAppBar(
              title: 'Sender Email Preferences',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width15,
                  Dimensions.width15,
                  Dimensions.width15,
                  Dimensions.width15 + Dimensions.listBottomSpace,
                ),
                child: Column(
                  children: [
                    // Public Domains Card
                    FormCard(
                      children: [
                        // Public Domains Header (tappable)
                        InkWell(
                          onTap: () => setState(
                            () => _publicDomainsExpanded =
                                !_publicDomainsExpanded,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: Dimensions.width10 * 0.4,
                                height: Dimensions.height20,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 * 0.13,
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.width10),
                              Expanded(
                                child: Text(
                                  'Public Domains',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ),
                              Icon(
                                _publicDomainsExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: context.colors.textSecondary,
                              ),
                            ],
                          ),
                        ),

                        // Description (always visible)
                        SizedBox(height: Dimensions.height15),
                        Text(
                          'Emails sent with the following addresses in the From field will be sent from message.service@sender.zohobooks.com to avoid landing in the spam folder.',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.8,
                            color: context.colors.textSecondary,
                            height: 1.4,
                          ),
                        ),

                        // Expandable content (domain + senders)
                        if (_publicDomainsExpanded) ...[
                          SizedBox(height: Dimensions.height15),

                          // Domain indicator
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: Dimensions.iconSize24,
                                color: AppColors.warning,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                'gmail.com',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.height15),

                          // Sender List
                          ..._senders.map((sender) => _buildSenderTile(sender)),
                        ],
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Choose How to Send Emails Card
                    FormCard(
                      children: [
                        InkWell(
                          onTap: _navigateToDeliveryMethod,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Choose How to Send Emails',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        fontWeight: FontWeight.w700,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10 * 0.4),
                                    Text(
                                      'Select how you want to send emails using public domain email addresses.',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.75,
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: context.colors.textSecondary,
                              ),
                            ],
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

  Widget _buildSenderTile(_SenderItem sender) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender.name,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        sender.email,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (sender.isPrimary) ...[
                      SizedBox(width: Dimensions.width10 / 2),
                      Icon(
                        Icons.star_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.warning,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz_rounded,
              color: context.colors.textSecondary,
            ),
            onPressed: () => _showSenderOptions(sender),
          ),
        ],
      ),
    );
  }
}

class _SenderItem {
  final String name;
  final String email;
  final bool isPrimary;

  _SenderItem({
    required this.name,
    required this.email,
    this.isPrimary = false,
  });
}
