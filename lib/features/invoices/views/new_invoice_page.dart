import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/views/add_invoice_line_item_page.dart';
import 'package:flutter/material.dart';

class NewInvoicePage extends StatefulWidget {
  final CustomerModel? customer;

  const NewInvoicePage({super.key, this.customer});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage>
    with UnsavedChangesMixin {
  // Controllers
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _salespersonController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _customerNotesController =
      TextEditingController();
  final TextEditingController _termsController = TextEditingController();

  // Form data
  final String _selectedTaxTreatment = 'VAT Registered';
  String _selectedPlaceOfSupply = 'Dubai';
  final String _invoiceNumber = 'INV-000039';
  DateTime _invoiceDate = DateTime.now();
  String _selectedTerms = 'Due on Receipt';
  DateTime _dueDate = DateTime.now();
  bool _isTaxInclusive = false;
  final List<String> _emailCommunications = [];
  bool _paymentReceived = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _customerNameController.text = widget.customer!.name;
      if (widget.customer!.email != null &&
          widget.customer!.email!.isNotEmpty) {
        _emailCommunications.add(widget.customer!.email!);
      }
    }
    _customerNotesController.text = 'Thanks for your business.';

    // Track changes for unsaved-changes protection
    _customerNameController.addListener(markDirty);
    _orderNumberController.addListener(markDirty);
    _salespersonController.addListener(markDirty);
    _subjectController.addListener(markDirty);
    _customerNotesController.addListener(markDirty);
    _termsController.addListener(markDirty);

    appLog('📄 NewInvoicePage initialized', name: 'NewInvoicePage');
  }

  @override
  void dispose() {
    _customerNameController.removeListener(markDirty);
    _orderNumberController.removeListener(markDirty);
    _salespersonController.removeListener(markDirty);
    _subjectController.removeListener(markDirty);
    _customerNotesController.removeListener(markDirty);
    _termsController.removeListener(markDirty);
    _customerNameController.dispose();
    _orderNumberController.dispose();
    _salespersonController.dispose();
    _subjectController.dispose();
    _customerNotesController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              CustomSliverAppBar(
                title: 'New Invoice',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(
                    label: 'SAVE AS DRAFT',
                    onPressed: _saveDraft,
                  ),
                  SizedBox(width: Dimensions.width10),
                  AppBarIconButton(
                    icon: Icons.more_vert_rounded,
                    color: context.colors.textSecondary,
                    onPressed: _showMoreOptions,
                  ),
                  SizedBox(width: Dimensions.width20),
                ],
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(Dimensions.width20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Customer Information Card
                    _CustomerInvoiceSection(
                      customer: _CustomerSection(
                        children: [
                          _buildCustomerNameField(),
                          SizedBox(height: Dimensions.height15),
                          _buildLinkRow([
                            _buildLink('Address', () {
                              appLog(
                                '📍 Address tapped',
                                name: 'NewInvoicePage',
                              );
                              ToastificationHelper.showInfo(
                                context,
                                'Select a customer to manage the address.',
                              );
                            }),
                            _buildLink('Customer Details', () {
                              appLog(
                                '👤 Customer Details tapped',
                                name: 'NewInvoicePage',
                              );
                              ToastificationHelper.showInfo(
                                context,
                                'Select a customer to view their details.',
                              );
                            }),
                          ]),
                          SizedBox(height: Dimensions.height20),
                          _buildTaxTreatmentRow(),
                          SizedBox(height: Dimensions.height20),
                          _buildDropdown(
                            'Place Of Supply',
                            _selectedPlaceOfSupply,
                            ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'],
                            isRequired: true,
                            onChanged: (value) {
                              setState(() => _selectedPlaceOfSupply = value!);
                            },
                          ),
                        ],
                      ),
                      invoiceDetails: _InvoiceDetailsSection(
                        children: [
                          _buildInvoiceNumberField(),
                          SizedBox(height: Dimensions.height20),
                          _buildTextField(
                            'Order Number',
                            _orderNumberController,
                          ),
                          SizedBox(height: Dimensions.height20),
                          _buildDateField(
                            'Invoice Date',
                            _invoiceDate,
                            isRequired: true,
                            onTap: () async {
                              final date = await _selectDate(
                                context,
                                _invoiceDate,
                              );
                              if (date != null) {
                                setState(() => _invoiceDate = date);
                              }
                            },
                          ),
                          SizedBox(height: Dimensions.height20),
                          _buildDropdown(
                            'Terms',
                            _selectedTerms,
                            [
                              'Due on Receipt',
                              'Net 15',
                              'Net 30',
                              'Net 45',
                              'Net 60',
                            ],
                            isRequired: true,
                            onChanged: (value) {
                              setState(() => _selectedTerms = value!);
                            },
                          ),
                          SizedBox(height: Dimensions.height20),
                          _buildDateField(
                            'Due Date',
                            _dueDate,
                            onTap: () async {
                              final date = await _selectDate(context, _dueDate);
                              if (date != null) {
                                setState(() => _dueDate = date);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Salesperson & Subject Card
                    _InvoiceDetailsCard(
                      children: [
                        _buildTextField(
                          'Salesperson',
                          _salespersonController,
                          placeholder: 'Select or Add Salesperson',
                          suffixIcon: Icons.keyboard_arrow_down_rounded,
                        ),
                        SizedBox(height: Dimensions.height20),
                        _buildTextField(
                          'Subject',
                          _subjectController,
                          placeholder: 'What is this invoice for?',
                          hasInfo: true,
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    _LineItemsTaxSection(
                      taxSelector: _buildTaxTypeSelector(),
                      addLineItemButton: _buildAddLineItemButton(),
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Customer Notes Card
                    _InvoiceNotesSection(
                      children: [
                        _buildSectionHeader('Customer Notes'),
                        SizedBox(height: Dimensions.height10),
                        _buildMultilineText(_customerNotesController.text),
                        SizedBox(height: Dimensions.height15),
                        _buildSectionHeader('Terms & Conditions'),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Email Communications Card
                    _EmailCommunicationsSection(
                      emails: _emailCommunications,
                      onClear: () {
                        setState(() => _emailCommunications.clear());
                        appLog(
                          '🗑️ Clear emails tapped',
                          name: 'NewInvoicePage',
                        );
                      },
                      onAdd: _addEmail,
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Payment Details Card
                    _PaymentDetailsSection(
                      children: [
                        _buildSectionHeader('Payment Details'),
                        SizedBox(height: Dimensions.height15),
                        _buildCheckbox(
                          'I have received the payment',
                          _paymentReceived,
                          (value) {
                            setState(() => _paymentReceived = value ?? false);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Attachments Card
                    _AttachmentsSection(
                      header: _buildSectionHeader('Attachments'),
                      onUpload: () {
                        appLog('📎 Upload File tapped', name: 'NewInvoicePage');
                        ToastificationHelper.showInfo(
                          context,
                          'File attachments are coming soon.',
                        );
                      },
                    ),

                    SizedBox(height: Dimensions.height30),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- Button actions --------
  void _saveDraft() {
    appLog('💾 Save as Draft tapped', name: 'NewInvoicePage');
    if (_customerNameController.text.trim().isEmpty) {
      ToastificationHelper.showError(
        context,
        'Please select a customer before saving.',
      );
      return;
    }
    ToastificationHelper.showSuccess(context, 'Invoice saved as draft.');
    Navigator.pop(context);
  }

  void _showMoreOptions() {
    appLog('⋮ More options pressed', name: 'NewInvoicePage');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
              ),
              _moreOptionTile(
                ctx,
                Icons.remove_red_eye_outlined,
                'Preview invoice',
                () => ToastificationHelper.showInfo(
                  context,
                  'Invoice preview is coming soon.',
                ),
              ),
              _moreOptionTile(ctx, Icons.send_rounded, 'Save and send', () {
                if (_customerNameController.text.trim().isEmpty) {
                  ToastificationHelper.showError(
                    context,
                    'Please select a customer before sending.',
                  );
                  return;
                }
                ToastificationHelper.showSuccess(
                  context,
                  'Invoice saved and sent.',
                );
                Navigator.pop(context);
              }),
              _moreOptionTile(ctx, Icons.refresh_rounded, 'Reset form', () {
                setState(() {
                  _customerNameController.clear();
                  _orderNumberController.clear();
                  _subjectController.clear();
                  _emailCommunications.clear();
                  _paymentReceived = false;
                });
                ToastificationHelper.showInfo(context, 'Form reset.');
              }),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        );
      },
    );
  }

  Widget _moreOptionTile(
    BuildContext sheetContext,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Appcolors.primary),
      title: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.9,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(sheetContext);
        onTap();
      },
    );
  }

  void _addEmail() {
    appLog('➕ Add New Email tapped', name: 'NewInvoicePage');
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
            decoration: const InputDecoration(hintText: 'name@example.com'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Appcolors.primary,
                side: const BorderSide(color: Appcolors.primary, width: 1.5),
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
                Navigator.pop(ctx);
                ToastificationHelper.showSuccess(context, 'Email added.');
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDropdownSheet(
    String label,
    String value,
    List<String> options,
    Function(String?)? onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              ...options.map((option) {
                final selected = option == value;
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: Appcolors.primary)
                      : null,
                  onTap: () {
                    onChanged?.call(option);
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        );
      },
    );
  }

  // Helper Methods
  Widget _buildSectionHeader(String label, {bool hasInfo = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: Appcolors.primary,
          ),
        ),
        if (hasInfo) ...[
          SizedBox(width: Dimensions.width10 / 2),
          Icon(
            Icons.info_outline,
            size: Dimensions.iconSize16,
            color: context.colors.textTertiary,
          ),
        ],
      ],
    );
  }

  Widget _buildCustomerNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Customer Name',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 3),
            Text(
              '*',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  _customerNameController.text.isEmpty
                      ? 'Select Customer'
                      : _customerNameController.text,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: _customerNameController.text.isEmpty
                        ? context.colors.textTertiary
                        : context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: () {
                setState(() => _customerNameController.clear());
                appLog('❌ Clear customer tapped', name: 'NewInvoicePage');
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.width10),
                child: Icon(
                  Icons.close_rounded,
                  size: Dimensions.iconSize24,
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkRow(List<Widget> links) {
    return Row(
      children: [
        for (int i = 0; i < links.length; i++) ...[
          if (i > 0) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: Text(
                '|',
                style: TextStyle(color: context.colors.textTertiary),
              ),
            ),
          ],
          links[i],
        ],
      ],
    );
  }

  Widget _buildLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          color: Appcolors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTaxTreatmentRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tax Treatment',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: () {
                appLog('✏️ Edit Tax Treatment tapped', name: 'NewInvoicePage');
                ToastificationHelper.showInfo(
                  context,
                  'Editing tax treatment is coming soon.',
                );
              },
              child: Icon(
                Icons.edit_outlined,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Text(
          _selectedTaxTreatment,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Invoice#',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 3),
            Text(
              '*',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  _invoiceNumber,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: () {
                appLog('⚙️ Invoice settings tapped', name: 'NewInvoicePage');
                ToastificationHelper.showInfo(
                  context,
                  'Invoice number settings are coming soon.',
                );
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: Dimensions.iconSize24,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    bool hasInfo = false,
    String? placeholder,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Appcolors.primary,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: Dimensions.width10 / 3),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
              if (hasInfo) ...[
                SizedBox(width: Dimensions.width10 / 2),
                Icon(
                  Icons.info_outline,
                  size: Dimensions.iconSize16,
                  color: context.colors.textTertiary,
                ),
              ],
            ],
          ),
          SizedBox(height: Dimensions.height10),
        ],
        TextField(
          controller: controller,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: context.colors.textTertiary,
              fontSize: Dimensions.font16 * 0.85,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: context.colors.textSecondary)
                : null,
            filled: true,
            fillColor: context.colors.surfaceLight,
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
              borderSide: BorderSide(color: Appcolors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options, {
    bool isRequired = false,
    Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                '*',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () => _showDropdownSheet(label, value, options, onChanged),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize24,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date, {
    bool isRequired = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: Dimensions.width10 / 3),
              Text(
                '*',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: Dimensions.iconSize16,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaxTypeSelector() {
    return Row(
      children: [
        Text(
          'Tax',
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(width: Dimensions.width20),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildRadioOption('Exclusive', !_isTaxInclusive)),
              SizedBox(width: Dimensions.width15),
              Expanded(child: _buildRadioOption('Inclusive', _isTaxInclusive)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _isTaxInclusive = label == 'Inclusive');
        appLog('💰 Tax type changed to: $label', name: 'NewInvoicePage');
      },
      child: Row(
        children: [
          Container(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Appcolors.primary : context.colors.border,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: Dimensions.iconSize24 / 2,
                      height: Dimensions.iconSize24 / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Appcolors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: Dimensions.width10),
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLineItemButton() {
    return GestureDetector(
      onTap: () async {
        appLog('➕ Add Line Item tapped', name: 'NewInvoicePage');
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddInvoiceLineItemPage(),
          ),
        );
        if (result != null && result is InvoiceLineItem) {
          appLog(
            '✅ Line item added: ${result.itemName}',
            name: 'NewInvoicePage',
          );
          if (!mounted) return;
          ToastificationHelper.showSuccess(
            context,
            '${result.itemName} added to invoice.',
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: Appcolors.primary, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              color: Appcolors.primary,
              size: Dimensions.iconSize24,
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              'Add Line Item',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w700,
                color: Appcolors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultilineText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Dimensions.font16 * 0.85,
        color: context.colors.textSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: Dimensions.iconSize24,
            height: Dimensions.iconSize24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius15 / 3),
              border: Border.all(
                color: value ? Appcolors.primary : context.colors.border,
                width: 2,
              ),
              color: value ? Appcolors.primary : Colors.transparent,
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: Dimensions.iconSize16,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSeed(
                  seedColor: Appcolors.primary,
                  brightness: Theme.of(context).brightness,
                ).copyWith(
                  primary: Appcolors.primary,
                  onSurface: context.colors.textPrimary,
                  surface: context.colors.card,
                ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _CustomerInvoiceSection extends StatelessWidget {
  final Widget customer;
  final Widget invoiceDetails;

  const _CustomerInvoiceSection({
    required this.customer,
    required this.invoiceDetails,
  });

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: [
        customer,
        SizedBox(height: Dimensions.height20),
        invoiceDetails,
      ],
    );
  }
}

class _CustomerSection extends StatelessWidget {
  final List<Widget> children;

  const _CustomerSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _InvoiceDetailsSection extends StatelessWidget {
  final List<Widget> children;

  const _InvoiceDetailsSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _InvoiceDetailsCard extends StatelessWidget {
  final List<Widget> children;

  const _InvoiceDetailsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: children,
    );
  }
}

class _LineItemsTaxSection extends StatelessWidget {
  final Widget taxSelector;
  final Widget addLineItemButton;

  const _LineItemsTaxSection({
    required this.taxSelector,
    required this.addLineItemButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormCard(
          borderRadius: Dimensions.radius20,
          showShadow: true,
          children: [taxSelector],
        ),
        SizedBox(height: Dimensions.height15),
        addLineItemButton,
      ],
    );
  }
}

class _InvoiceNotesSection extends StatelessWidget {
  final List<Widget> children;

  const _InvoiceNotesSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: children,
    );
  }
}

class _EmailCommunicationsSection extends StatelessWidget {
  final List<String> emails;
  final VoidCallback onClear;
  final VoidCallback onAdd;

  const _EmailCommunicationsSection({
    required this.emails,
    required this.onClear,
    required this.onAdd,
  });

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
              onTap: onClear,
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
        if (emails.isNotEmpty) ...[
          SizedBox(height: Dimensions.height15),
          ...emails.map((email) => _EmailItem(email: email)),
        ],
        SizedBox(height: Dimensions.height15),
        GestureDetector(
          onTap: onAdd,
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

class _EmailItem extends StatelessWidget {
  final String email;

  const _EmailItem({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _PaymentDetailsSection extends StatelessWidget {
  final List<Widget> children;

  const _PaymentDetailsSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: children,
    );
  }
}

class _AttachmentsSection extends StatelessWidget {
  final Widget header;
  final VoidCallback onUpload;

  const _AttachmentsSection({required this.header, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      borderRadius: Dimensions.radius20,
      showShadow: true,
      children: [
        header,
        SizedBox(height: Dimensions.height15),
        GestureDetector(
          onTap: onUpload,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: context.colors.border, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: context.colors.textSecondary,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Upload File',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textSecondary,
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
