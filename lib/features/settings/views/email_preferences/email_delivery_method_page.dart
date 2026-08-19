import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class EmailDeliveryMethodPage extends StatefulWidget {
  const EmailDeliveryMethodPage({super.key});

  @override
  State<EmailDeliveryMethodPage> createState() =>
      _EmailDeliveryMethodPageState();
}

class _EmailDeliveryMethodPageState extends State<EmailDeliveryMethodPage> {
  String _selectedMethod = 'zoho_books';

  @override
  void initState() {
    super.initState();
    appLog(
      '📧 EmailDeliveryMethodPage initialized',
      name: 'EmailDeliveryMethod',
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
              title: 'Emails Delivery Method',
              leadingType: AppBarLeadingType.back,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: RadioGroup<String>(
                  groupValue: _selectedMethod,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMethod = val);
                  },
                  child: FormCard(
                    children: [
                      // Zoho Books Email Address Option
                      _buildRadioOption(
                        title: 'Zoho Books Email Address',
                        description:
                            'Emails will show message-service@sender-zohobooks.com in the From field, while replies will go to the primary contact\'s email address, miscellaneous4826@gmail.com',
                        value: 'zoho_books',
                      ),
                      SizedBox(height: Dimensions.height15),
                      Divider(color: context.colors.border),
                      SizedBox(height: Dimensions.height15),

                      // Sender's Email Address Option
                      _buildRadioOption(
                        title: 'Sender\'s Email Address',
                        description:
                            'Emails will show your email address in the From field. To prevent emails from going to spam, we recommend using the Zoho Books email address.',
                        value: 'sender',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String description,
    required String value,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedMethod = value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                SizedBox(height: Dimensions.height10 / 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.8,
                    color: context.colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Radio<String>(
            value: value,
          ),
        ],
      ),
    );
  }
}
