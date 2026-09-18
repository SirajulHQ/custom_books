import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/bills/models/bill_model.dart';
import 'package:custom_books/features/bills/widgets/vendor_picker_sheet.dart';
import 'package:flutter/material.dart';

class AddBillPage extends StatefulWidget {
  final BillModel? existing;

  const AddBillPage({super.key, this.existing});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> with UnsavedChangesMixin {
  final _billNumController = TextEditingController();
  final _amountController = TextEditingController();

  String? _vendorName;
  DateTime _billDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 15));
  bool _isLoading = true;

  static const List<String> _vendors = [
    'Global Supplies',
    'Metro Traders',
    'Al Noor Co',
    'Prime Distributors',
  ];

  @override
  void initState() {
    super.initState();
    _load();
    if (widget.existing != null) {
      final b = widget.existing!;
      _billNumController.text = b.billNumber;
      _amountController.text = b.total.toStringAsFixed(2);
      _vendorName = b.vendorName.isEmpty ? null : b.vendorName;
      _billDate = b.billDate;
      _dueDate = b.dueDate;
    } else {
      _billNumController.text = 'BILL-00043';
    }
    _billNumController.addListener(markDirty);
    _amountController.addListener(markDirty);
  }

  @override
  void dispose() {
    _billNumController.removeListener(markDirty);
    _amountController.removeListener(markDirty);
    _billNumController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Simulates preparing the form so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _pickDate({required bool isDueDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDueDate ? _dueDate : _billDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _billDate = picked;
        }
      });
    }
  }

  Future<void> _selectVendor() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (_) => VendorPickerSheet(vendors: _vendors),
    );
    if (selected != null) {
      setState(() => _vendorName = selected);
    }
  }

  void _saveBill({BillStatus status = BillStatus.draft}) {
    if (_vendorName == null || _vendorName!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Vendor.');
      return;
    }
    if (_billNumController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Bill Number.');
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter an Amount.');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    final newBill = BillModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      billNumber: _billNumController.text.trim(),
      vendorName: _vendorName!.trim(),
      billDate: _billDate,
      dueDate: _dueDate,
      status: status,
      total: amount,
      balanceDue: amount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newBill);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: SafeArea(
          child: _isLoading
              ? const FormPageSkeleton()
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CustomSliverAppBar(
                      title: widget.existing == null ? 'New Bill' : 'Edit Bill',
                      leadingType: AppBarLeadingType.back,
                      onLeadingPressed: () =>
                          onPopInvokedWithResult(false, null),
                      actions: [
                        AppBarElevatedButton(
                          label: 'SAVE AS DRAFT',
                          onPressed: () => _saveBill(status: BillStatus.draft),
                        ),
                        SizedBox(width: Dimensions.width10),
                        AppBarIconButton(
                          icon: Icons.more_vert_rounded,
                          color: AppColors.accent,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => Container(
                                decoration: BoxDecoration(
                                  color: context.colors.card,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                      Dimensions.radius20 * 1.2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const BottomSheetDragHandle(),
                                    ListTile(
                                      leading: Icon(
                                        Icons.save_rounded,
                                        color: AppColors.primary,
                                      ),
                                      title: Text(
                                        'Save as Open',
                                        style: TextStyle(
                                          fontSize: Dimensions.font16 * 0.9,
                                          fontWeight: FontWeight.w600,
                                          color: context.colors.textPrimary,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(ctx);
                                        _saveBill(status: BillStatus.open);
                                      },
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: Dimensions.width20),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(Dimensions.width15),
                        child: Column(
                          children: [
                            FormCard(
                              children: [
                                const RequiredLabel(text: 'Vendor'),
                                SizedBox(height: Dimensions.height10 / 2),
                                InkWell(
                                  onTap: _selectVendor,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: context.colors.border,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _vendorName ?? "Select a vendor",
                                            style: TextStyle(
                                              fontSize: Dimensions.font16 * 0.9,
                                              color: _vendorName == null
                                                  ? context.colors.textTertiary
                                                  : context.colors.textPrimary,
                                              fontWeight: _vendorName == null
                                                  ? FontWeight.normal
                                                  : FontWeight.w600,
                                            ),
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
                                SizedBox(height: Dimensions.height20),

                                const RequiredLabel(text: 'Bill#'),
                                SizedBox(height: Dimensions.height10 / 2),
                                TextField(
                                  controller: _billNumController,
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
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height20),

                                const RequiredLabel(text: 'Bill Date'),
                                SizedBox(height: Dimensions.height10 / 2),
                                _dateField(formatDate(_billDate), () {
                                  _pickDate(isDueDate: false);
                                }),
                                SizedBox(height: Dimensions.height20),

                                const RequiredLabel(text: 'Due Date'),
                                SizedBox(height: Dimensions.height10 / 2),
                                _dateField(formatDate(_dueDate), () {
                                  _pickDate(isDueDate: true);
                                }),
                              ],
                            ),
                            SizedBox(height: Dimensions.height15),

                            FormCard(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const RequiredLabel(text: 'Amount'),
                                    FormNumberField(
                                      controller: _amountController,
                                      hint: '0.00',
                                      prefix: '₹',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _dateField(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: FormTextStyles.value(context)),
            Icon(
              Icons.calendar_today_outlined,
              size: Dimensions.iconSize24 * 0.85,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
