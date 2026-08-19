import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _category = 'General';
  int _rating = 0;

  final List<String> _categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'Performance',
    'UI/UX',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_messageController.text.trim().isEmpty) {
      ToastificationHelper.showError(context, 'Please enter your feedback.');
      return;
    }
    appLog(
      '📤 Feedback submitted: category=$_category, rating=$_rating',
      name: 'Feedback',
    );
    ToastificationHelper.showSuccess(context, 'Thank you for your feedback!');
    Navigator.pop(context);
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
              title: 'Feedback',
              leadingType: AppBarLeadingType.back,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: Dimensions.height15),

                  // Rating
                  Text(
                    'How would you rate your experience?',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _rating = starIndex),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: Dimensions.width10 / 2,
                          ),
                          child: Icon(
                            starIndex <= _rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: Dimensions.iconSize24 * 1.5,
                            color: starIndex <= _rating
                                ? AppColors.warning
                                : context.colors.textTertiary,
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Category
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.card,
                      border: Border.all(color: context.colors.border),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _category,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.colors.textSecondary,
                        ),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textPrimary,
                        ),
                        dropdownColor: context.colors.card,
                        items: _categories
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _category = val ?? _category),
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Subject
                  Text(
                    'Subject',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _subjectController,
                    style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                    decoration: _inputDecoration('Brief summary'),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Message
                  Text(
                    'Your Feedback',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _messageController,
                    maxLines: 6,
                    style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                    decoration: _inputDecoration('Tell us what you think...'),
                  ),

                  SizedBox(height: Dimensions.height30),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                      ),
                      child: Text(
                        'Submit Feedback',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.colors.textTertiary),
      filled: true,
      fillColor: context.colors.card,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
