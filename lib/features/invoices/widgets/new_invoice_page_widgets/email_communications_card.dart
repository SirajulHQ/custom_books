import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class EmailCommunicationsCard extends StatefulWidget {
  const EmailCommunicationsCard({
    super.key,
    this.initialEmails = const [],
    this.onChanged,
  });

  final List<String> initialEmails;
  final ValueChanged<List<String>>? onChanged;

  @override
  State<EmailCommunicationsCard> createState() =>
      _EmailCommunicationsCardState();
}

class _EmailCommunicationsCardState extends State<EmailCommunicationsCard> {
  late final List<String> _emailCommunications;

  @override
  void initState() {
    super.initState();
    _emailCommunications = List<String>.from(widget.initialEmails);
  }

  void _notifyChanged() {
    widget.onChanged?.call(List<String>.from(_emailCommunications));
  }

  void _clearEmails() {
    setState(() => _emailCommunications.clear());
    _notifyChanged();
    appLog('🗑️ Clear emails tapped', name: 'EmailCommunicationsCard');
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Email Communications',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.primary,
                  ),
                ),
                SizedBox(width: Dimensions.width10 / 2),
                Icon(
                  Icons.info_outline,
                  size: Dimensions.iconSize16,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
            GestureDetector(
              onTap: _clearEmails,
              child: Text(
                'Clear',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (_emailCommunications.isNotEmpty) ...[
          SizedBox(height: Dimensions.height15),
          ..._emailCommunications.map(
            (email) => Container(
              margin: EdgeInsets.only(bottom: Dimensions.height10),
              padding: EdgeInsets.all(Dimensions.width15),
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Appcolors.primary,
                    size: Dimensions.iconSize24,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: Dimensions.height15),
        GestureDetector(
          onTap: () {
            appLog('➕ Add New Email tapped', name: 'EmailCommunicationsCard');
            final controller = TextEditingController();

            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: context.colors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  title: Text(
                    'Add email',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'name@example.com',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Appcolors.primary,
                        side: const BorderSide(
                          color: Appcolors.primary,
                          width: 1.5,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        final email = controller.text.trim();
                        if (email.isEmpty || !email.contains('@')) {
                          ToastificationHelper.showError(
                            context,
                            'Please enter a valid email address.',
                          );
                          return;
                        }
                        setState(() => _emailCommunications.add(email));
                        _notifyChanged();
                        Navigator.pop(ctx);
                        ToastificationHelper.showSuccess(
                          context,
                          'Email added.',
                        );
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: Appcolors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Appcolors.primary,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Add New',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: Appcolors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
