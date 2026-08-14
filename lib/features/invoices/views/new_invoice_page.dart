import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/customers/models/customer_model.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/widgets/custom_date_field.dart';
import 'package:custom_books/features/invoices/widgets/custom_dropdown_field.dart';
import 'package:custom_books/features/invoices/widgets/custom_text_field.dart';
import 'package:custom_books/features/invoices/widgets/email_communications_card.dart';
import 'package:custom_books/features/invoices/widgets/invoice_form_helpers.dart';
import 'package:custom_books/features/invoices/widgets/invoice_number_field.dart';
import 'package:custom_books/features/invoices/widgets/invoice_tax_and_line_item_section.dart';
import 'package:custom_books/features/invoices/widgets/select_customer_bottom_sheet.dart';
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
  final List<InvoiceLineItem> _lineItems = [];
  List<String> _emailCommunications = [];
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
                    onPressed: () {
                      appLog('💾 Save as Draft tapped', name: 'NewInvoicePage');
                      if (_customerNameController.text.trim().isEmpty) {
                        ToastificationHelper.showError(
                          context,
                          'Please select a customer before saving.',
                        );
                        return;
                      }
                      ToastificationHelper.showSuccess(
                        context,
                        'Invoice saved as draft.',
                      );
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: Dimensions.width10),
                  AppBarIconButton(
                    icon: Icons.more_vert_rounded,
                    color: context.colors.textSecondary,
                    onPressed: () {
                      appLog('⋮ More options pressed', name: 'NewInvoicePage');
                      SelectCustomerBottomSheet.show(
                        context,
                        isCustomerSelected: _customerNameController.text
                            .trim()
                            .isNotEmpty,
                        onResetForm: () {
                          setState(() {
                            _customerNameController.clear();
                            _orderNumberController.clear();
                            _subjectController.clear();
                            _emailCommunications.clear();
                            _paymentReceived = false;
                          });
                        },
                      );
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
                    FormCard(
                      borderRadius: Dimensions.radius20,
                      showShadow: true,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
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
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radius15,
                                          ),
                                          border: Border.all(
                                            color: context.colors.border,
                                          ),
                                        ),
                                        child: Text(
                                          _customerNameController.text.isEmpty
                                              ? 'Select Customer'
                                              : _customerNameController.text,
                                          style: TextStyle(
                                            fontSize: Dimensions.font16 * 0.85,
                                            color:
                                                _customerNameController
                                                    .text
                                                    .isEmpty
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
                                        setState(
                                          () => _customerNameController.clear(),
                                        );
                                        appLog(
                                          '❌ Clear customer tapped',
                                          name: 'NewInvoicePage',
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          Dimensions.width10,
                                        ),
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
                            ),
                            SizedBox(height: Dimensions.height15),
                            InvoiceFormHelpers.buildLinkRow(context, [
                              GestureDetector(
                                onTap: () {
                                  appLog(
                                    '📍 Address tapped',
                                    name: 'NewInvoicePage',
                                  );
                                  ToastificationHelper.showInfo(
                                    context,
                                    'Select a customer to manage the address.',
                                  );
                                },
                                child: Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    color: Appcolors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  appLog(
                                    '👤 Customer Details tapped',
                                    name: 'NewInvoicePage',
                                  );
                                  ToastificationHelper.showInfo(
                                    context,
                                    'Select a customer to view their details.',
                                  );
                                },
                                child: Text(
                                  'Customer Details',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    color: Appcolors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(height: Dimensions.height20),
                            Column(
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
                                        appLog(
                                          '✏️ Edit Tax Treatment tapped',
                                          name: 'NewInvoicePage',
                                        );
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
                            ),
                            SizedBox(height: Dimensions.height20),
                            CustomDropdownField(
                              label: 'Place Of Supply',
                              value: _selectedPlaceOfSupply,
                              options: const [
                                'Dubai',
                                'Abu Dhabi',
                                'Sharjah',
                                'Ajman',
                              ],
                              isRequired: true,
                              onChanged: (value) {
                                setState(() => _selectedPlaceOfSupply = value!);
                              },
                              onShowSheet: _showDropdownSheet,
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InvoiceNumberField(
                              invoiceNumber: _invoiceNumber,
                              onSettingsTap: () {
                                appLog(
                                  '⚙️ Invoice settings tapped',
                                  name: 'NewInvoicePage',
                                );
                                ToastificationHelper.showInfo(
                                  context,
                                  'Invoice number settings are coming soon.',
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.height20),

                            CustomTextField(
                              label: 'Order Number',
                              controller: _orderNumberController,
                            ),
                            SizedBox(height: Dimensions.height20),
                            CustomDateField(
                              label: 'Invoice Date',
                              date: _invoiceDate,
                              isRequired: true,
                              onDateSelected: (picked) {
                                setState(() => _invoiceDate = picked);
                              },
                            ),
                            SizedBox(height: Dimensions.height20),
                            CustomDropdownField(
                              label: 'Terms',
                              value: _selectedTerms,
                              options: const [
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
                              onShowSheet: _showDropdownSheet,
                            ),
                            SizedBox(height: Dimensions.height20),
                            CustomDateField(
                              label: 'Due Date',
                              date: _dueDate,
                              isRequired: true,
                              onDateSelected: (picked) {
                                setState(() => _dueDate = picked);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Salesperson & Subject Card
                    FormCard(
                      borderRadius: Dimensions.radius20,
                      showShadow: true,
                      children: [
                        CustomTextField(
                          label: 'Salesperson',
                          controller: _salespersonController,
                          placeholder: 'Select or Add Salesperson',
                          suffixIcon: Icons.keyboard_arrow_down_rounded,
                        ),
                        SizedBox(height: Dimensions.height20),
                        CustomTextField(
                          label: 'Subject',
                          controller: _subjectController,
                          placeholder: 'What is this invoice for?',
                          hasInfo: true,
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Tax & Line Items Section
                    InvoiceTaxAndLineItemSection(
                      isTaxInclusive: _isTaxInclusive,
                      onTaxTypeChanged: (value) {
                        setState(() => _isTaxInclusive = value);
                        markDirty();
                      },
                      onLineItemAdded: (item) {
                        setState(() => _lineItems.add(item));
                        markDirty();
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Customer Notes Card
                    FormCard(
                      borderRadius: Dimensions.radius20,
                      showShadow: true,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Customer Notes",
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
                        SizedBox(height: Dimensions.height10),
                        Text(
                          _customerNotesController.text,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            color: context.colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),
                        InvoiceFormHelpers.buildSectionHeader(
                          context,
                          'Terms & Conditions',
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Email Communications Card
                    EmailCommunicationsCard(
                      initialEmails: _emailCommunications,
                      onChanged: (emails) => _emailCommunications = emails,
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Payment Details Card
                    FormCard(
                      borderRadius: Dimensions.radius20,
                      showShadow: true,
                      children: [
                        InvoiceFormHelpers.buildSectionHeader(
                          context,
                          'Payment Details',
                        ),
                        SizedBox(height: Dimensions.height15),
                        GestureDetector(
                          onTap: () => (value) {
                            setState(() => _paymentReceived = value ?? false);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: Dimensions.iconSize24,
                                height: Dimensions.iconSize24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 / 3,
                                  ),
                                  border: Border.all(
                                    color: _paymentReceived
                                        ? Appcolors.primary
                                        : context.colors.border,
                                    width: 2,
                                  ),
                                  color: _paymentReceived
                                      ? Appcolors.primary
                                      : Colors.transparent,
                                ),
                                child: _paymentReceived
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
                                  'I have received the payment',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    color: context.colors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Attachments Card
                    FormCard(
                      borderRadius: Dimensions.radius20,
                      showShadow: true,
                      children: [
                        InvoiceFormHelpers.buildSectionHeader(
                          context,
                          'Attachments',
                        ),
                        SizedBox(height: Dimensions.height15),
                        GestureDetector(
                          onTap: () {
                            appLog(
                              '📎 Upload File tapped',
                              name: 'NewInvoicePage',
                            );
                            ToastificationHelper.showInfo(
                              context,
                              'File attachments are coming soon.',
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width20,
                              vertical: Dimensions.height20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(
                                color: context.colors.border,
                                width: 2,
                              ),
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

  void _showDropdownSheet(
    String label,
    String value,
    List<String> options,
    Function(String?)? onChanged,
  ) {
    InvoiceFormHelpers.showDropdownSheet(
      context,
      label: label,
      value: value,
      options: options,
      onChanged: onChanged,
    );
  }
}
