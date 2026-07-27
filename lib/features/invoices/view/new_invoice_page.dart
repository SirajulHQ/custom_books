import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/view/add_invoice_line_item_page.dart';
import 'package:flutter/material.dart';

class NewInvoicePage extends StatefulWidget {
  final CustomerModel? customer;

  const NewInvoicePage({super.key, this.customer});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
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
    appLog('📄 NewInvoicePage initialized', name: 'NewInvoicePage');
  }

  @override
  void dispose() {
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

    return Scaffold(
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            CustomSliverAppBar(
              title: 'New Invoice',
              leadingType: AppBarLeadingType.back,
              onLeadingPressed: () {
                appLog('⬅️ Back button tapped', name: 'NewInvoicePage');
                Navigator.pop(context);
              },
              actions: [
                AppBarElevatedButton(
                  label: 'SAVE AS DRAFT',
                  onPressed: () {
                    appLog('💾 Save as Draft tapped', name: 'NewInvoicePage');
                    // TODO: Implement save draft functionality
                  },
                ),
                SizedBox(width: Dimensions.width10),
                AppBarIconButton(
                  icon: Icons.more_vert_rounded,
                  color: Appcolors.textSecondary,
                  onPressed: () {
                    appLog('⋮ More options pressed', name: 'NewInvoicePage');
                    // TODO: Show more options
                  },
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
                            appLog('📍 Address tapped', name: 'NewInvoicePage');
                          }),
                          _buildLink('Customer Details', () {
                            appLog(
                              '👤 Customer Details tapped',
                              name: 'NewInvoicePage',
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
                        _buildTextField('Order Number', _orderNumberController),
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
                      appLog('🗑️ Clear emails tapped', name: 'NewInvoicePage');
                    },
                    onAdd: () {
                      appLog('➕ Add New Email tapped', name: 'NewInvoicePage');
                      // TODO: Show email input dialog
                    },
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
                      // TODO: Show file picker
                    },
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
            color: Appcolors.textTertiary,
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
                  color: Appcolors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: Appcolors.border),
                ),
                child: Text(
                  _customerNameController.text.isEmpty
                      ? 'Select Customer'
                      : _customerNameController.text,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: _customerNameController.text.isEmpty
                        ? Appcolors.textTertiary
                        : Appcolors.textPrimary,
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
                  color: Appcolors.textTertiary,
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
              child: Text('|', style: TextStyle(color: Appcolors.textTertiary)),
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
                color: Appcolors.textSecondary,
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: () {
                appLog('✏️ Edit Tax Treatment tapped', name: 'NewInvoicePage');
              },
              child: Icon(
                Icons.edit_outlined,
                size: Dimensions.iconSize16,
                color: Appcolors.textSecondary,
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
            color: Appcolors.textPrimary,
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
                  color: Appcolors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: Appcolors.border),
                ),
                child: Text(
                  _invoiceNumber,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: Appcolors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: () {
                appLog('⚙️ Invoice settings tapped', name: 'NewInvoicePage');
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: Appcolors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: Appcolors.border),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: Dimensions.iconSize24,
                  color: Appcolors.textSecondary,
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
                  color: Appcolors.textTertiary,
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
            color: Appcolors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Appcolors.textTertiary,
              fontSize: Dimensions.font16 * 0.85,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Appcolors.textSecondary)
                : null,
            filled: true,
            fillColor: Appcolors.surfaceLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.border),
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
          onTap: () {
            // TODO: Show dropdown bottom sheet
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height15,
            ),
            decoration: BoxDecoration(
              color: Appcolors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: Appcolors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      color: Appcolors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSize24,
                  color: Appcolors.textSecondary,
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
              color: Appcolors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: Appcolors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: Appcolors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: Dimensions.iconSize16,
                  color: Appcolors.textSecondary,
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
            color: Appcolors.textSecondary,
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
                color: isSelected ? Appcolors.primary : Appcolors.border,
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
                  ? Appcolors.textPrimary
                  : Appcolors.textSecondary,
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
          // TODO: Add line item to list
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
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
        color: Appcolors.textSecondary,
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
                color: value ? Appcolors.primary : Appcolors.border,
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
                color: Appcolors.textPrimary,
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
            colorScheme: ColorScheme.light(
              primary: Appcolors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Appcolors.textPrimary,
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
                  color: Appcolors.textTertiary,
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
              color: const Color(0xFFE3F2FD),
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
        color: const Color(0xFFE3F2FD),
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
                color: Appcolors.textPrimary,
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
              border: Border.all(color: Appcolors.border, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Appcolors.textSecondary,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Upload File',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: Appcolors.textSecondary,
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
