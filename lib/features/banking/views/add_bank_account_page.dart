import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/banking/widgets/bank_account_form_widgets.dart';
import 'package:custom_books/features/banking/widgets/currency_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage>
    with UnsavedChangesMixin {
  String _selectedAccountType = 'Bank';
  bool _makePrimary = false;
  String _selectedCurrency = 'INR- Indian Rupee';

  final _accountNameController = TextEditingController();
  final _accountCodeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _currencies = [
    'INR- Indian Rupee',
    'AUD- Australian Dollar',
    'BND- Brunei Dollar',
    'CAD- Canadian Dollar',
    'CNY- Yuan Renminbi',
    'EUR- Euro',
    'GBP- Pound Sterling',
    'JPY- Japanese Yen',
    'SAR- Saudi Riyal',
    'USD- United States Dollar',
    'ZAR- South African Rand',
  ];

  @override
  void initState() {
    super.initState();
    _accountNameController.addListener(markDirty);
    _accountCodeController.addListener(markDirty);
    _accountNumberController.addListener(markDirty);
    _bankNameController.addListener(markDirty);
    _ifscCodeController.addListener(markDirty);
    _descriptionController.addListener(markDirty);
  }

  @override
  void dispose() {
    _accountNameController.removeListener(markDirty);
    _accountCodeController.removeListener(markDirty);
    _accountNumberController.removeListener(markDirty);
    _bankNameController.removeListener(markDirty);
    _ifscCodeController.removeListener(markDirty);
    _descriptionController.removeListener(markDirty);
    _accountNameController.dispose();
    _accountCodeController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'Add Bank or Credit Card',
                subtitle: 'Fill in the account details',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(
                    label: 'SAVE',
                    onPressed: () {
                      // Validate required fields
                      if (_accountNameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter account name'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      ToastificationHelper.showSuccess(
                        context,
                        '${_accountNameController.text.trim()} saved successfully.',
                      );
                      markClean();
                      Navigator.pop(context);
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
                    // Account Type and Details Card
                    BankFormCard(
                      children: [
                        // Account Type Selection
                        Text(
                          'Select Account Type',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        Container(
                          decoration: BoxDecoration(
                            color: context.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15 / 2,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10,
                            vertical: Dimensions.height10 / 2,
                          ),
                          child: Column(
                            children: [
                              BankFormRadioOption(
                                label: 'Bank',
                                icon: Icons.account_balance_outlined,
                                isSelected: _selectedAccountType == 'Bank',
                                onTap: () {
                                  setState(() => _selectedAccountType = 'Bank');
                                  markDirty();
                                },
                              ),
                              BankFormRadioOption(
                                label: 'Credit Card',
                                icon: Icons.credit_card_outlined,
                                isSelected:
                                    _selectedAccountType == 'Credit Card',
                                onTap: () {
                                  setState(
                                    () => _selectedAccountType = 'Credit Card',
                                  );
                                  markDirty();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                        Divider(height: 1, color: context.colors.border),
                        SizedBox(height: Dimensions.height20),

                        // Account Name
                        BankFormTextField(
                          label: 'Account Name',
                          controller: _accountNameController,
                          isRequired: true,
                          icon: Icons.account_balance_wallet_outlined,
                          hint: 'Enter Account Name',
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Account Code
                        BankFormTextField(
                          label: 'Account Code',
                          controller: _accountCodeController,
                          icon: Icons.numbers_outlined,
                          hint: 'Enter Account Code',
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Currency
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.currency_exchange_outlined,
                                  size: Dimensions.iconSize16,
                                  color: context.colors.textSecondary,
                                ),
                                SizedBox(width: Dimensions.width10 / 2),
                                Text(
                                  'Currency',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: Dimensions.font16 * 0.85,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            GestureDetector(
                              onTap: () {
                                CurrencyBottomSheet.show(
                                  context,
                                  selectedCurrency: _selectedCurrency,
                                  currencies: _currencies,
                                  onCurrencySelected: (currency) {
                                    setState(() {
                                      _selectedCurrency = currency;
                                    });
                                    markDirty();
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width15,
                                  vertical: Dimensions.height15,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceLight,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 / 2,
                                  ),
                                  border: Border.all(
                                    color: context.colors.border,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedCurrency,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.85,
                                        color: context.colors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: context.colors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Bank Details Card
                    BankFormCard(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 / 2,
                                ),
                              ),
                              child: Icon(
                                Icons.account_balance_outlined,
                                size: Dimensions.iconSize16 * 1.2,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Text(
                              'Bank Details',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.95,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Account Number
                        BankFormTextField(
                          label: 'Account Number',
                          controller: _accountNumberController,
                          icon: Icons.tag_outlined,
                          hint: 'Enter Account Number',
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Bank Name
                        BankFormTextField(
                          label: 'Bank Name',
                          controller: _bankNameController,
                          icon: Icons.domain_outlined,
                          hint: 'Enter Bank Name',
                        ),
                        SizedBox(height: Dimensions.height20),

                        // IFSC Code
                        BankFormTextField(
                          label: 'IFSC Code',
                          controller: _ifscCodeController,
                          icon: Icons.qr_code_outlined,
                          hint: 'Enter IFSC Code',
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Additional Information Card
                    BankFormCard(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 / 2,
                                ),
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                size: Dimensions.iconSize16 * 1.2,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Text(
                              'Additional Information',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.95,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Description
                        BankFormTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          icon: Icons.notes_outlined,
                          hint: 'Max. 500 characters',
                          maxLines: 4,
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Make this primary checkbox
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _makePrimary = !_makePrimary;
                            });
                            markDirty();
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: Dimensions.iconSize24,
                                height: Dimensions.iconSize24,
                                child: Checkbox(
                                  value: _makePrimary,
                                  onChanged: (value) {
                                    setState(() {
                                      _makePrimary = value ?? false;
                                    });
                                    markDirty();
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius15 * 0.27,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                'Make this primary',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.85,
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
}
