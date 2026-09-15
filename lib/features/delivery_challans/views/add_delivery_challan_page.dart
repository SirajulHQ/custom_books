import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/delivery_challans/models/delivery_challan_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddDeliveryChallanPage extends StatefulWidget {
  final DeliveryChallanModel? existing;

  const AddDeliveryChallanPage({super.key, this.existing});

  @override
  State<AddDeliveryChallanPage> createState() => _AddDeliveryChallanPageState();
}

class _AddDeliveryChallanPageState extends State<AddDeliveryChallanPage>
    with UnsavedChangesMixin {
  final _customerController = TextEditingController();
  final _challanNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _challanDate = DateTime.now();
  String _type = 'Job Work';

  static const List<String> _customers = [
    'Nandhu',
    'Parthiv Ajith',
    'Amal',
    'Nabeel',
    'Tech Geum',
  ];

  static const List<String> _typeOptions = [
    'Job Work',
    'Supply on Approval',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _challanNumController.text = 'DC-00043';
    if (widget.existing != null) {
      final c = widget.existing!;
      _challanNumController.text = c.challanNumber;
      _customerController.text = c.customerName;
      _referenceController.text = c.referenceNumber;
      _amountController.text = c.total.toStringAsFixed(2);
      _challanDate = c.challanDate;
      _type = c.type;
    }
    _customerController.addListener(markDirty);
    _challanNumController.addListener(markDirty);
    _referenceController.addListener(markDirty);
    _amountController.addListener(markDirty);
  }

  @override
  void dispose() {
    _customerController.removeListener(markDirty);
    _challanNumController.removeListener(markDirty);
    _referenceController.removeListener(markDirty);
    _amountController.removeListener(markDirty);
    _customerController.dispose();
    _challanNumController.dispose();
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _challanDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _challanDate = picked);
      markDirty();
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

  Future<void> _selectType() async {
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
                'Type',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._typeOptions.map(
              (type) => ListTile(
                title: Text(
                  type,
                  style: TextStyle(
                    color: type == _type
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: type == _type
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: type == _type
                    ? Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, type),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _type = selected);
      markDirty();
    }
  }

  void _saveChallan({
    DeliveryChallanStatus status = DeliveryChallanStatus.draft,
  }) {
    if (_customerController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Customer.');
      return;
    }
    if (_challanNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Challan Number.',
      );
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final newChallan = DeliveryChallanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challanNumber: _challanNumController.text.trim(),
      customerName: _customerController.text.trim(),
      referenceNumber: _referenceController.text.trim(),
      challanDate: _challanDate,
      type: _type,
      status: status,
      total: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newChallan);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: widget.existing == null
              ? 'New Delivery Challan'
              : 'Edit Delivery Challan',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: () =>
                  _saveChallan(status: DeliveryChallanStatus.draft),
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
                if (val == 'save_delivered') {
                  _saveChallan(status: DeliveryChallanStatus.delivered);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'save_delivered',
                  child: Text('Save as Delivered'),
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

                  // Challan# *
                  const RequiredLabel(text: 'Challan#'),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _challanNumController,
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

                  // Challan Date *
                  const RequiredLabel(text: 'Challan Date'),
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
                            formatDate(_challanDate),
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

                  // Type
                  Text('Type', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: _selectType,
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
                          Text(_type, style: FormTextStyles.value(context)),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: Dimensions.iconSize24,
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
