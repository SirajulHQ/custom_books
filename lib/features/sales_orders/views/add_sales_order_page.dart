import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/dashed_border.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/customers/views/add_customer_page.dart';
import 'package:custom_books/features/sales_orders/models/sales_order_model.dart';
import 'package:custom_books/features/sales_orders/views/add_sales_order_line_item_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSalesOrderPage extends StatefulWidget {
  final int orderSequence;

  const AddSalesOrderPage({super.key, this.orderSequence = 313});

  @override
  State<AddSalesOrderPage> createState() => _AddSalesOrderPageState();
}

class _AddSalesOrderPageState extends State<AddSalesOrderPage>
    with UnsavedChangesMixin {
  final _customerController = TextEditingController();
  final _salesOrderNumController = TextEditingController();
  final _referenceController = TextEditingController();
  final _deliveryMethodController = TextEditingController();
  final _notesController = TextEditingController();
  final _termsController = TextEditingController();

  DateTime _salesOrderDate = DateTime.now();
  DateTime? _expectedShipmentDate;
  String _paymentTerms = 'Due on Receipt';
  String? _salesperson;
  bool _taxInclusive = false;

  final List<SalesOrderLineItem> _lineItems = [];
  final List<PlatformFile> _attachments = [];

  static const List<String> _customers = [
    'Nandhu',
    'Parthiv Ajith',
    'Amal',
    'Nabeel',
    'Tech Geum',
  ];

  static const List<String> _paymentTermsOptions = [
    'Due on Receipt',
    'Net 15',
    'Net 30',
    'Net 60',
    'Due end of month',
  ];

  static const List<String> _salespeopleOptions = [
    'Select or Add Salesperson',
    'Own Store',
    'Parthiv P',
    'Aarav Menon',
  ];

  @override
  void initState() {
    super.initState();
    _salesOrderNumController.text =
        'SO-${widget.orderSequence.toString().padLeft(5, '0')}';
    _customerController.addListener(markDirty);
    _salesOrderNumController.addListener(markDirty);
    _referenceController.addListener(markDirty);
    _deliveryMethodController.addListener(markDirty);
    _notesController.addListener(markDirty);
    _termsController.addListener(markDirty);
  }

  @override
  void dispose() {
    _customerController.removeListener(markDirty);
    _salesOrderNumController.removeListener(markDirty);
    _referenceController.removeListener(markDirty);
    _deliveryMethodController.removeListener(markDirty);
    _notesController.removeListener(markDirty);
    _termsController.removeListener(markDirty);
    _customerController.dispose();
    _salesOrderNumController.dispose();
    _referenceController.dispose();
    _deliveryMethodController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isShipmentDate}) async {
    final initialDate = isShipmentDate
        ? (_expectedShipmentDate ??
              _salesOrderDate.add(const Duration(days: 7)))
        : _salesOrderDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isShipmentDate) {
          _expectedShipmentDate = picked;
        } else {
          _salesOrderDate = picked;
        }
      });
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
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Customer',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 1.1,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    color: AppColors.primary,
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      nav.pop();
                      final newCust = await nav.push<String>(
                        MaterialPageRoute(
                          builder: (_) => const AddCustomerPage(),
                        ),
                      );
                      if (newCust != null && mounted) {
                        setState(() => _customerController.text = newCust);
                      }
                    },
                  ),
                ],
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

  Future<void> _selectPaymentTerms() async {
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
                'Payment Terms',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._paymentTermsOptions.map(
              (term) => ListTile(
                title: Text(
                  term,
                  style: TextStyle(
                    color: term == _paymentTerms
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: term == _paymentTerms
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: term == _paymentTerms
                    ? Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, term),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _paymentTerms = selected);
    }
  }

  Future<void> _selectSalesperson() async {
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
                'Salesperson',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._salespeopleOptions.map(
              (person) => ListTile(
                title: Text(
                  person,
                  style: TextStyle(
                    color: person == _salesperson
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: person == _salesperson
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                onTap: () => Navigator.pop(context, person),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _salesperson = selected == 'Select or Add Salesperson'
            ? null
            : selected;
      });
    }
  }

  Future<void> _addLineItem() async {
    final result = await Navigator.push<SalesOrderLineItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddSalesOrderLineItemPage()),
    );

    if (result != null && mounted) {
      setState(() => _lineItems.add(result));
    }
  }

  Future<void> _pickAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null && mounted) {
        final existingNames = _attachments.map((f) => f.name).toSet();
        setState(() {
          for (final file in result.files) {
            if (!existingNames.contains(file.name)) {
              _attachments.add(file);
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ToastificationHelper.showError(context, 'Error picking file');
      }
    }
  }

  void _saveOrder({SalesOrderStatus status = SalesOrderStatus.draft}) {
    if (_customerController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Customer.');
      return;
    }
    if (_salesOrderNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(
        context,
        'Please enter a Sales Order Number.',
      );
      return;
    }

    final newOrder = SalesOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      salesOrderNumber: _salesOrderNumController.text.trim(),
      customerName: _customerController.text.trim(),
      referenceNumber: _referenceController.text.trim(),
      salesOrderDate: _salesOrderDate,
      expectedShipmentDate: _expectedShipmentDate,
      paymentTerms: _paymentTerms,
      deliveryMethod: _deliveryMethodController.text.trim(),
      salesperson: _salesperson ?? '',
      taxInclusive: _taxInclusive,
      lineItems: _lineItems,
      customerNotes: _notesController.text.trim(),
      termsAndConditions: _termsController.text.trim(),
      attachments: _attachments.map((f) => f.name).toList(),
      status: status,
      isInvoiced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newOrder);
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
          title: 'New Sales Order',
          backgroundColor: context.colors.card,
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: () => _saveOrder(status: SalesOrderStatus.draft),
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
                if (val == 'save_confirmed') {
                  _saveOrder(status: SalesOrderStatus.confirmed);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'save_confirmed',
                  child: Text('Save as Confirmed'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.width15),
          child: Column(
            children: [
              // Card 1: Core Details
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

                  // Sales Order# *
                  const RequiredLabel(text: 'Sales Order#'),
                  SizedBox(height: Dimensions.height10 / 2),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _salesOrderNumController,
                          style: FormTextStyles.value(context),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.colors.border,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.colors.border,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Icon(
                        Icons.settings_outlined,
                        size: Dimensions.iconSize24 * 0.85,
                        color: context.colors.textSecondary,
                      ),
                    ],
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
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  // Sales Order Date *
                  const RequiredLabel(text: 'Sales Order Date'),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: () => _pickDate(isShipmentDate: false),
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
                            dateFormat.format(_salesOrderDate),
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

                  // Expected Shipment Date
                  Text('Expected Shipment Date', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: () => _pickDate(isShipmentDate: true),
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
                            _expectedShipmentDate != null
                                ? dateFormat.format(_expectedShipmentDate!)
                                : 'dd MMM yyyy',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              color: _expectedShipmentDate != null
                                  ? context.colors.textPrimary
                                  : context.colors.textTertiary,
                            ),
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

                  // Payment Terms
                  Text('Payment Terms', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: _selectPaymentTerms,
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
                            _paymentTerms,
                            style: FormTextStyles.value(context),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: Dimensions.iconSize24,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),

              // Card 2: Delivery & Salesperson
              FormCard(
                children: [
                  Text('Delivery Method', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _deliveryMethodController,
                    style: FormTextStyles.value(context),
                    decoration: InputDecoration(
                      hintText: 'Select or Type to add',
                      hintStyle: TextStyle(
                        color: context.colors.textTertiary,
                        fontSize: Dimensions.font16 * 0.9,
                      ),
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
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text('Salesperson', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: _selectSalesperson,
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
                            _salesperson ?? 'Select or Add Salesperson',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              color: _salesperson != null
                                  ? context.colors.textPrimary
                                  : context.colors.textTertiary,
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
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),

              // Card 3: Tax Radios
              FormCard(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax', style: FormTextStyles.label()),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _taxInclusive = false),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: _taxInclusive,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) =>
                                      setState(() => _taxInclusive = val!),
                                ),
                                Text(
                                  'Exclusive',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimensions.width15),
                          GestureDetector(
                            onTap: () => setState(() => _taxInclusive = true),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: _taxInclusive,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) =>
                                      setState(() => _taxInclusive = val!),
                                ),
                                Text(
                                  'Inclusive',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.9,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),

              // Card 4: Line Items
              FormCard(
                children: [
                  if (_lineItems.isNotEmpty) ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lineItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = _lineItems[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            'Qty: ${item.quantity} x ₹${item.rate.toStringAsFixed(2)} | Tax: ${item.taxRate}%',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${item.net.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: Dimensions.iconSize20,
                                ),
                                onPressed: () =>
                                    setState(() => _lineItems.removeAt(index)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _addLineItem,
                      icon: Icon(
                        Icons.add_circle_rounded,
                        color: AppColors.primary,
                        size: Dimensions.iconSize24 * 0.85,
                      ),
                      label: Text(
                        'Add Line Item',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Dimensions.font16 * 0.95,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: 1.2),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20 * 1.5,
                          vertical: Dimensions.height15 * 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),

              // Card 5: Notes & Terms
              FormCard(
                children: [
                  Text('Customer Notes', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
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
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text('Terms & Conditions', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  TextField(
                    controller: _termsController,
                    maxLines: 2,
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
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),

              // Card 6: Attachments
              FormCard(
                children: [
                  Text('Attachments', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height15),
                  DashedBorder(
                    color: context.colors.border,
                    borderRadius: Dimensions.radius15,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimensions.height20),
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _pickAttachments,
                        icon: Icon(
                          Icons.image_outlined,
                          color: context.colors.textPrimary,
                          size: Dimensions.iconSize24 * 0.85,
                        ),
                        label: Text(
                          'Upload File',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.colors.border),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15 / 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_attachments.isNotEmpty) ...[
                    SizedBox(height: Dimensions.height15),
                    Wrap(
                      spacing: Dimensions.width10 * 0.8,
                      runSpacing: Dimensions.height10 * 0.8,
                      children: _attachments
                          .map(
                            (file) => Chip(
                              avatar: Icon(
                                Icons.insert_drive_file_outlined,
                                size: Dimensions.iconSize16,
                              ),
                              label: Text(file.name),
                              onDeleted: () =>
                                  setState(() => _attachments.remove(file)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}
