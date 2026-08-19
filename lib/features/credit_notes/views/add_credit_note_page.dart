import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/credit_notes/models/credit_note_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCreditNotePage extends StatefulWidget {
  const AddCreditNotePage({super.key});

  @override
  State<AddCreditNotePage> createState() => _AddCreditNotePageState();
}

class _AddCreditNotePageState extends State<AddCreditNotePage>
    with UnsavedChangesMixin {
  final _customerController = TextEditingController();
  final _creditNoteNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _creditNoteDate = DateTime.now();

  static const List<String> _customers = [
    'Nandhu',
    'Parthiv Ajith',
    'Amal',
    'Nabeel',
    'Tech Geum',
  ];

  @override
  void initState() {
    super.initState();
    _creditNoteNumController.text = 'CN-00016';
    _customerController.addListener(markDirty);
    _creditNoteNumController.addListener(markDirty);
    _referenceController.addListener(markDirty);
    _amountController.addListener(markDirty);
  }

  @override
  void dispose() {
    _customerController.removeListener(markDirty);
    _creditNoteNumController.removeListener(markDirty);
    _referenceController.removeListener(markDirty);
    _amountController.removeListener(markDirty);
    _customerController.dispose();
    _creditNoteNumController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _creditNoteDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _creditNoteDate = picked);
    }
  }

  Future<void> _selectCustomer() async {
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
                'Select Customer',
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
                children: [
                  ..._customers.map(
                    (name) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(color: context.colors.textPrimary),
                      ),
                      onTap: () => Navigator.pop(context, name),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _customerController.text = selected);
    }
  }

  void _saveNote({CreditNoteStatus status = CreditNoteStatus.draft}) {
    if (_customerController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Customer.');
      return;
    }
    if (_creditNoteNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Credit Note Number.',
      );
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newNote = CreditNoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      creditNoteNumber: _creditNoteNumController.text.trim(),
      customerName: _customerController.text.trim(),
      referenceNumber: _referenceController.text.trim(),
      creditNoteDate: _creditNoteDate,
      status: status,
      total: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: 'New Credit Note',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: () => _saveNote(status: CreditNoteStatus.draft),
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
                if (val == 'save_open') {
                  _saveNote(status: CreditNoteStatus.open);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'save_open',
                  child: Text('Save as Open'),
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
                  // Customer Name *
                  const RequiredLabel(text: 'Customer Name'),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: _selectCustomer,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10 / 2,
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
                          Expanded(
                            child: Text(
                              _customerController.text.isEmpty
                                  ? 'Start typing to select a Customer'
                                  : _customerController.text,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                color: _customerController.text.isEmpty
                                    ? context.colors.textTertiary
                                    : context.colors.textPrimary,
                                fontWeight: _customerController.text.isEmpty
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add_rounded,
                            size: Dimensions.iconSize24,
                            color: context.colors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  // Credit Note# *
                  const RequiredLabel(text: 'Credit Note#'),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _creditNoteNumController,
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

                  // Credit Note Date *
                  const RequiredLabel(text: 'Credit Note Date'),
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
                            dateFormat.format(_creditNoteDate),
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
            ],
          ),
        ),
      ),
    );
  }
}
