import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/manual_journals/models/manual_journal_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddManualJournalPage extends StatefulWidget {
  const AddManualJournalPage({super.key});

  @override
  State<AddManualJournalPage> createState() => _AddManualJournalPageState();
}

class _AddManualJournalPageState extends State<AddManualJournalPage> {
  final _journalNumberController = TextEditingController(text: 'JN-00016');
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _journalDate = DateTime.now();

  @override
  void dispose() {
    _journalNumberController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _journalDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _journalDate = picked);
    }
  }

  void _saveJournal({ManualJournalStatus status = ManualJournalStatus.draft}) {
    if (_journalNumberController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Journal Number.',
      );
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newJournal = ManualJournalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      journalNumber: _journalNumberController.text.trim(),
      referenceNumber: _referenceController.text.trim(),
      journalDate: _journalDate,
      notes: _notesController.text.trim(),
      status: status,
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newJournal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'New Manual Journal',
        backgroundColor: context.colors.card,
        actions: [
          TextButton(
            onPressed: () => _saveJournal(status: ManualJournalStatus.draft),
            child: Text(
              'SAVE AS DRAFT',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: Dimensions.font16 * 0.75,
                letterSpacing: 0.5,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.colors.textPrimary,
            ),
            onSelected: (val) {
              if (val == 'save_published') {
                _saveJournal(status: ManualJournalStatus.published);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'save_published',
                child: Text('Save as Published'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          children: [
            FormCard(
              children: [
                // Journal# *
                const RequiredLabel(text: 'Journal#'),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _journalNumberController,
                  style: FormTextStyles.value(context),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // Reference#
                Text('Reference#', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _referenceController,
                  style: FormTextStyles.value(context),
                  decoration: InputDecoration(
                    hintText: 'Enter reference',
                    hintStyle: TextStyle(color: context.colors.textTertiary),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // Journal Date *
                const RequiredLabel(text: 'Journal Date'),
                SizedBox(height: Dimensions.height10 / 2),
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDate(_journalDate),
                          style: FormTextStyles.value(context),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.iconSize24 * 0.85,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // Amount (₹) *
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const RequiredLabel(text: 'Amount (₹)'),
                    FormNumberField(
                      controller: _amountController,
                      hint: '0.00',
                      prefix: '₹',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),

            // Notes
            FormCard(
              children: [
                Text('Notes', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  style: FormTextStyles.value(context),
                  decoration: InputDecoration(
                    hintText: 'Add notes',
                    hintStyle: TextStyle(color: context.colors.textTertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius15 / 2,
                      ),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
