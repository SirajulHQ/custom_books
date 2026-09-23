import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/image_helper.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/items/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen for adjusting an item's stock quantity (and, optionally, its cost).
///
/// Mirrors the reference "Adjust Stock" flow: pick a date and account, enter a
/// new quantity on hand (or a signed adjustment), optionally edit the cost
/// price, choose a reason and reference, then save as draft or convert to
/// adjusted.
class AdjustStockPage extends StatefulWidget {
  final ItemModel item;

  const AdjustStockPage({super.key, required this.item});

  @override
  State<AdjustStockPage> createState() => _AdjustStockPageState();
}

class _AdjustStockPageState extends State<AdjustStockPage>
    with UnsavedChangesMixin {
  final _newQuantityController = TextEditingController();
  final _quantityAdjustedController = TextEditingController();
  final _referenceController = TextEditingController();

  DateTime _date = DateTime.now();
  late String _account;
  String? _reason;
  late double _costPrice;

  /// Guards against the two quantity fields recomputing each other in a loop.
  bool _syncingQuantities = false;

  double get _quantityAvailable => widget.item.openingStock ?? 0.0;

  static const List<String> _accountOptions = [
    'Cost of Goods Sold',
    'Inventory Asset',
    'Inventory Shrinkage',
    'Opening Stock',
    'Other Expenses',
  ];

  static const List<String> _reasonOptions = [
    'Damaged goods',
    'Stock count correction',
    'Warehouse transfer shortfall',
    'Expired stock',
    'Theft or loss',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _account = _accountOptions.first;
    _costPrice = widget.item.purchasePrice;
    _newQuantityController.addListener(_onNewQuantityChanged);
    _quantityAdjustedController.addListener(_onAdjustedChanged);
    _referenceController.addListener(markDirty);
    appLog(
      '📦 AdjustStockPage opened for ${widget.item.name}',
      name: 'AdjustStockPage',
    );
  }

  @override
  void dispose() {
    _newQuantityController.removeListener(_onNewQuantityChanged);
    _quantityAdjustedController.removeListener(_onAdjustedChanged);
    _referenceController.removeListener(markDirty);
    _newQuantityController.dispose();
    _quantityAdjustedController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  /// When the user types a new quantity on hand, derive the adjustment.
  void _onNewQuantityChanged() {
    if (_syncingQuantities) return;
    markDirty();
    final newQty = double.tryParse(_newQuantityController.text.trim());
    _syncingQuantities = true;
    if (newQty == null) {
      _quantityAdjustedController.clear();
    } else {
      final diff = newQty - _quantityAvailable;
      _quantityAdjustedController.text = _formatSigned(diff);
    }
    _syncingQuantities = false;
  }

  /// When the user types an adjustment, derive the new quantity on hand.
  void _onAdjustedChanged() {
    if (_syncingQuantities) return;
    markDirty();
    final adjusted = double.tryParse(
      _quantityAdjustedController.text.trim().replaceAll('+', ''),
    );
    _syncingQuantities = true;
    if (adjusted == null) {
      _newQuantityController.clear();
    } else {
      _newQuantityController.text = (_quantityAvailable + adjusted)
          .toStringAsFixed(2);
    }
    _syncingQuantities = false;
  }

  String _formatSigned(double value) {
    final v = value.toStringAsFixed(2);
    return value > 0 ? '+$v' : v;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
      markDirty();
    }
  }

  void _showAccountSheet() {
    _showSelectionSheet(
      title: 'Account',
      options: _accountOptions,
      selected: _account,
      onSelected: (value) {
        setState(() => _account = value);
        markDirty();
      },
    );
  }

  void _showReasonSheet() {
    _showSelectionSheet(
      title: 'Reason',
      options: _reasonOptions,
      selected: _reason,
      onSelected: (value) {
        setState(() => _reason = value);
        markDirty();
      },
    );
  }

  Future<void> _editCostPrice() async {
    final controller = TextEditingController(
      text: _costPrice.toStringAsFixed(2),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: context.colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        title: Text(
          'Edit Cost Price',
          style: TextStyle(
            fontSize: Dimensions.font20 * 0.9,
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          style: FormTextStyles.value(context),
          decoration: FormTextStyles.inputDecoration(context, '0.00'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              Navigator.pop(dialogCtx, value);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      setState(() => _costPrice = result);
      markDirty();
    }
  }

  bool _validate() {
    if (_quantityAdjustedController.text.trim().isEmpty &&
        _newQuantityController.text.trim().isEmpty) {
      ToastificationHelper.showError(
        context,
        'Enter a new quantity or an adjustment.',
      );
      return false;
    }
    if (_reason == null) {
      ToastificationHelper.showError(context, 'Please select a reason.');
      return false;
    }
    return true;
  }

  void _saveAsDraft() {
    appLog('💾 Adjust stock saved as draft', name: 'AdjustStockPage');
    markClean();
    ToastificationHelper.showSuccess(context, 'Saved as draft.');
    Navigator.pop(context);
  }

  void _convertToAdjusted() {
    if (!_validate()) return;
    appLog('✅ Adjust stock converted to adjusted', name: 'AdjustStockPage');
    markClean();
    ToastificationHelper.showSuccess(context, 'Stock adjusted successfully.');
    Navigator.pop(context, true);
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
              CustomSliverAppBar(
                title: 'Adjust Stock',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
              ),
              SliverToBoxAdapter(child: _buildItemHeader()),
              SliverPadding(
                padding: EdgeInsets.all(Dimensions.width20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildDateAccountCard(),
                    SizedBox(height: Dimensions.height15),
                    _buildQuantityCard(),
                    SizedBox(height: Dimensions.height15),
                    _buildReasonCard(),
                    SizedBox(height: Dimensions.height30),
                  ]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomActions(),
      ),
    );
  }

  // ── Item header ────────────────────────────────────────────────────────────
  Widget _buildItemHeader() {
    final item = widget.item;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimensions.width20,
        Dimensions.height10,
        Dimensions.width20,
        Dimensions.height15,
      ),
      child: Row(
        children: [
          Container(
            width: Dimensions.height45 * 1.4,
            height: Dimensions.height45 * 1.4,
            decoration: BoxDecoration(
              color: context.colors.surfaceLight,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imageUrl != null
                ? ImageHelper.buildImage(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: _placeholderIcon(),
                  )
                : _placeholderIcon(),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: Dimensions.font20 * 0.95,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderIcon() {
    return Icon(
      Icons.image_outlined,
      size: Dimensions.iconSize24 * 1.3,
      color: context.colors.textTertiary,
    );
  }

  // ── Date + Account ───────────────────────────────────────────────────────
  Widget _buildDateAccountCard() {
    return FormCard(
      children: [
        const FormLabel(text: 'Date', required: true),
        InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          onTap: _pickDate,
          child: InputDecorator(
            decoration: FormTextStyles.inputDecoration(
              context,
              '',
              suffixIcon: Icon(
                Icons.calendar_today_rounded,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
            ),
            child: Text(
              formatDate(_date),
              style: FormTextStyles.value(context),
            ),
          ),
        ),
        const FormLabel(text: 'Account', required: true),
        _buildDropdownField(value: _account, onTap: _showAccountSheet),
      ],
    );
  }

  // ── Quantity + Cost ─────────────────────────────────────────────────────
  Widget _buildQuantityCard() {
    return FormCard(
      children: [
        // Quantity Available (read-only strip)
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height15,
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceLight,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity Available',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                _quantityAvailable.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New quantity on hand', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  _quantityInput(_newQuantityController, hint: '0.00'),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RequiredLabel(text: 'Quantity Adjusted'),
                  SizedBox(height: Dimensions.height10 / 2),
                  _quantityInput(
                    _quantityAdjustedController,
                    hint: 'Eg. +10, -10',
                    signed: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height15),
        Row(
          children: [
            Text(
              'Cost Price: AED${_costPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 2),
            GestureDetector(
              onTap: _editCostPrice,
              child: Icon(
                Icons.edit_outlined,
                size: Dimensions.iconSize16,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quantityInput(
    TextEditingController controller, {
    required String hint,
    bool signed = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: signed,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          signed ? RegExp(r'^-?\+?\d*\.?\d*') : RegExp(r'^\d*\.?\d*'),
        ),
      ],
      style: FormTextStyles.value(context),
      decoration: FormTextStyles.inputDecoration(context, hint),
    );
  }

  // ── Reason + Reference ───────────────────────────────────────────────────
  Widget _buildReasonCard() {
    return FormCard(
      children: [
        const FormLabel(text: 'Reason', required: true),
        _buildDropdownField(
          value: _reason,
          hint: 'Select a reason',
          onTap: _showReasonSheet,
        ),
        const FormLabel(text: 'Reference#'),
        TextField(
          controller: _referenceController,
          style: FormTextStyles.value(context),
          decoration: FormTextStyles.inputDecoration(context, ''),
        ),
      ],
    );
  }

  // ── Shared dropdown field (opens a selection sheet) ──────────────────────
  Widget _buildDropdownField({
    required String? value,
    String hint = '',
    required VoidCallback onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: InputDecorator(
        decoration: FormTextStyles.inputDecoration(
          context,
          '',
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.colors.textSecondary,
          ),
        ),
        child: Text(
          hasValue ? value : hint,
          style: hasValue
              ? FormTextStyles.value(context)
              : TextStyle(
                  color: context.colors.textTertiary,
                  fontSize: Dimensions.font16 * 0.82,
                ),
        ),
      ),
    );
  }

  void _showSelectionSheet({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetDragHandle(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: Dimensions.height20),
                  children: options.map((option) {
                    final isSelected = option == selected;
                    return ListTile(
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: isSelected
                            ? AppColors.primary
                            : context.colors.textSecondary,
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(sheetContext);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Bottom actions ───────────────────────────────────────────────────────
  Widget _buildBottomActions() {
    return SafeArea(
      child: Container(
        color: context.colors.card,
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height10,
          Dimensions.width20,
          Dimensions.height10,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _saveAsDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  minimumSize: Size(0, Dimensions.height45 * 1.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                ),
                child: Text(
                  'Save as Draft',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: ElevatedButton(
                onPressed: _convertToAdjusted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size(0, Dimensions.height45 * 1.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                ),
                child: Text(
                  'Convert to Adjusted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
