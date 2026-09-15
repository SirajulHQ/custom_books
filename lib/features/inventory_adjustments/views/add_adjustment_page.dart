import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/dashed_border.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/models/line_item_model.dart';
import 'package:custom_books/features/inventory_adjustments/views/add_line_item_page.dart';
import 'package:custom_books/features/inventory_adjustments/widgets/adjustment_form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewAdjustmentPage extends StatefulWidget {
  final InventoryAdjustment? existing;

  const NewAdjustmentPage({super.key, this.existing});

  @override
  State<NewAdjustmentPage> createState() => _NewAdjustmentPageState();
}

class _NewAdjustmentPageState extends State<NewAdjustmentPage>
    with UnsavedChangesMixin {
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  ModeOfAdjustment _mode = ModeOfAdjustment.quantity;
  DateTime _date = DateTime.now();
  String? _account = 'Cost of Goods Sold';
  String? _reason;

  final List<String> _accounts = const [
    'Cost of Goods Sold',
    'Inventory Asset',
    'Inventory Shrinkage',
    'Other Expense',
  ];

  final List<String> _reasons = const [
    'Damaged goods',
    'Stock count correction',
    'Warehouse transfer shortfall',
    'Expired stock',
    'Theft or loss',
    'Others',
  ];

  final List<LineItem> _lineItems = [];
  final List<PlatformFile> _attachments = [];

  // ── Attachment constants ───────────────────────────────────────────────────
  static const int _maxAttachments = 5;
  static const int _maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB

  // ── Show the main Attachments dialog ──────────────────────────────────────
  void _showAttachmentsDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return Dialog(
              backgroundColor: context.colors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              insetPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height45 * 1.2,
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Attachments',
                            style: TextStyle(
                              fontSize: Dimensions.font20 * 0.95,
                              fontWeight: FontWeight.w800,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          icon: Container(
                            padding: EdgeInsets.all(Dimensions.width10 * 0.4),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: context.colors.border),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: Dimensions.iconSize16,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Divider(height: 1, color: context.colors.border),
                    SizedBox(height: Dimensions.height10),

                    // ── Attachment list / empty state ────────────────────────
                    if (_attachments.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height30,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.width20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.07,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.attach_file_rounded,
                                size: Dimensions.iconSize24 * 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height15),
                            Text(
                              'No attachments yet',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.95,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2),
                            Text(
                              'You can add up to $_maxAttachments attachments,\neach not exceeding 10 MB.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: context.colors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: Dimensions.height80 * 3.25,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _attachments.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: Dimensions.height10 / 2),
                          itemBuilder: (_, i) {
                            final file = _attachments[i];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width15,
                                vertical: Dimensions.height10,
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
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      Dimensions.width10 * 0.7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius15 / 2,
                                      ),
                                    ),
                                    child: Icon(
                                      _fileIcon(file.extension),
                                      size: Dimensions.iconSize24 - 4,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          file.name,
                                          style: TextStyle(
                                            fontSize: Dimensions.font16 * 0.85,
                                            fontWeight: FontWeight.w600,
                                            color: context.colors.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        if (file.size > 0)
                                          Text(
                                            _formatBytes(file.size),
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.font16 * 0.72,
                                              color:
                                                  context.colors.textSecondary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: Dimensions.iconSize16 + 2,
                                      color: context.colors.textSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() => _attachments.removeAt(i));
                                      markDirty();
                                      setDialogState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: Dimensions.height20),

                    // ── Hint when list has items ─────────────────────────────
                    if (_attachments.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Text(
                          '${_attachments.length}/$_maxAttachments attachments · max 10 MB each',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.75,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),

                    // ── Add Attachment button ────────────────────────────────
                    if (_attachments.length < _maxAttachments)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _showSourcePicker(dialogCtx, setDialogState),
                          icon: Icon(
                            Icons.add_rounded,
                            color: AppColors.primary,
                            size: Dimensions.iconSize24 - 4,
                          ),
                          label: Text(
                            'Add Attachment',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius30,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height15,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Source picker bottom-sheet (Take Photo / Pick from Device) ─────────────
  void _showSourcePicker(BuildContext dialogCtx, StateSetter setDialogState) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Attachment',
                style: TextStyle(
                  fontSize: Dimensions.font20 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _sourceRow(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                subtitle: 'Capture using your camera',
                onTap: () async {
                  Navigator.pop(context); // close bottom-sheet
                  await _addFromCamera(setDialogState);
                },
              ),
              SizedBox(height: Dimensions.height10),
              _sourceRow(
                icon: Icons.folder_open_outlined,
                label: 'Pick from Device',
                subtitle: 'Browse files on your device',
                onTap: () async {
                  Navigator.pop(context); // close bottom-sheet
                  await _addFromDevice(setDialogState);
                },
              ),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        ),
      ),
    );
  }

  // ── Camera source ──────────────────────────────────────────────────────────
  Future<void> _addFromCamera(StateSetter setDialogState) async {
    final picker = ImagePicker();
    try {
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1080,
      );
      if (photo == null) return;

      final bytes = await photo.length();
      if (bytes > _maxFileSizeBytes) {
        if (mounted) {
          ToastificationHelper.showWarning(
            context,
            'File exceeds 10 MB limit.',
          );
        }
        return;
      }
      final pf = PlatformFile(name: photo.name, size: bytes, path: photo.path);
      final exists = _attachments.any((f) => f.name == pf.name);
      if (!exists) {
        setState(() => _attachments.add(pf));
        markDirty();
        setDialogState(() {});
      }
    } catch (e) {
      if (mounted) {
        ToastificationHelper.showWarning(context, 'Could not open camera.');
      }
    }
  }

  // ── Device file source ─────────────────────────────────────────────────────
  Future<void> _addFromDevice(StateSetter setDialogState) async {
    final remaining = _maxAttachments - _attachments.length;
    if (remaining <= 0) return;

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: remaining > 1,
      type: FileType.any,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;

    final existing = _attachments.map((f) => f.name).toSet();
    final toAdd = <PlatformFile>[];
    final oversized = <String>[];

    for (final f in result.files) {
      if (existing.contains(f.name)) continue;
      if (f.size > _maxFileSizeBytes) {
        oversized.add(f.name);
        continue;
      }
      toAdd.add(f);
      if (_attachments.length + toAdd.length >= _maxAttachments) break;
    }

    if (oversized.isNotEmpty && mounted) {
      ToastificationHelper.showWarning(
        context,
        '${oversized.length} file(s) skipped — each must be under 10 MB.',
      );
    }
    if (toAdd.isNotEmpty) {
      setState(() => _attachments.addAll(toAdd));
      markDirty();
      setDialogState(() {});
    }
  }

  // ── Reusable source option row for the bottom-sheet ───────────────────────
  Widget _sourceRow({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: Dimensions.iconSize24,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.75,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24 - 4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _date = existing.date;
      _reason = _reasons.contains(existing.reason) ? existing.reason : null;
    }
    _referenceController.addListener(markDirty);
    _descriptionController.addListener(markDirty);
  }

  @override
  void dispose() {
    _referenceController.removeListener(markDirty);
    _descriptionController.removeListener(markDirty);
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double get _totalQuantity =>
      _lineItems.fold(0.0, (sum, item) => sum + item.quantityAdjusted);

  double get _totalValue =>
      _lineItems.fold(0.0, (sum, item) => sum + item.valueChange);

  bool get _isValid =>
      _account != null && _reason != null && _lineItems.isNotEmpty;

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

  Future<void> _addLineItem() async {
    final result = await Navigator.push<LineItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddLineItemPage()),
    );
    if (result != null) {
      setState(() => _lineItems.add(result));
      markDirty();
    }
  }

  Future<void> _editLineItem(LineItem item) async {
    final result = await Navigator.push<LineItem>(
      context,
      MaterialPageRoute(builder: (_) => AddLineItemPage(initial: item)),
    );
    if (result != null) {
      setState(() {
        final index = _lineItems.indexWhere((i) => i.id == item.id);
        if (index != -1) _lineItems[index] = result;
      });
      markDirty();
    }
  }

  void _removeLineItem(String id) {
    setState(() => _lineItems.removeWhere((i) => i.id == id));
    markDirty();
  }

  void _save() {
    if (!_isValid) {
      ToastificationHelper.showWarning(
        context,
        'Please fill Account, Reason, and add at least one line item.',
      );
      return;
    }
    final now = DateTime.now();
    final adjustment = InventoryAdjustment(
      id: now.millisecondsSinceEpoch.toString(),
      reason: _reason!,
      date: _date,
      createdBy: 'You',
      quantityChange: _totalQuantity.round(),
      value: _totalValue,
      status: AdjustmentStatus.draft,
      createdAt: now,
      lastModifiedAt: now,
    );
    markClean();
    Navigator.pop(context, adjustment);
  }

  /// Returns a human-readable file size string (e.g. "2.3 MB").
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Picks a material icon that matches the file extension.
  IconData _fileIcon(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Icons.table_chart_outlined;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomBackAppBar(
          title: widget.existing == null ? 'New Adjustment' : 'Edit Adjustment',
          onLeadingPressed: () => onPopInvokedWithResult(false, null),
          actions: [
            TextButton(
              onPressed: _save,
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: context.colors.textSecondary,
                size: Dimensions.iconSize24 - 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              onSelected: (value) {
                if (value == 'discard') Navigator.pop(context);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'discard', child: Text('Discard')),
              ],
            ),
            SizedBox(width: Dimensions.width10),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height15,
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              FormCard(
                children: [
                  Text('Mode of adjustment', style: FormTextStyles.label()),
                  SizedBox(height: Dimensions.height10 / 2),
                  Row(
                    children: [
                      AdjustmentRadioOption(
                        label: 'Quantity',
                        value: ModeOfAdjustment.quantity,
                        selectedValue: _mode,
                        onChanged: (newMode) {
                          setState(() => _mode = newMode);
                          markDirty();
                        },
                      ),
                      SizedBox(width: Dimensions.width20),
                      AdjustmentRadioOption(
                        label: 'Value',
                        value: ModeOfAdjustment.value,
                        selectedValue: _mode,
                        onChanged: (newMode) {
                          setState(() => _mode = newMode);
                          markDirty();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              FormCard(
                children: [
                  Text('Reference#', style: FormTextStyles.label()),
                  TextField(
                    controller: _referenceController,
                    style: FormTextStyles.value(context),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height15),
                  RequiredLabel(text: 'Date'),
                  SizedBox(height: Dimensions.height10 / 2),
                  InkWell(
                    onTap: _pickDate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDate(_date),
                          style: FormTextStyles.value(context),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.iconSize24 - 6,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height15),
                  RequiredLabel(text: 'Account'),
                  SizedBox(height: Dimensions.height10 / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _account,
                      isExpanded: true,
                      style: FormTextStyles.value(context),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: context.colors.textSecondary,
                      ),
                      items: _accounts
                          .map(
                            (a) => DropdownMenuItem(value: a, child: Text(a)),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _account = v);
                        markDirty();
                      },
                    ),
                  ),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height15),
                  RequiredLabel(text: 'Reason'),
                  SizedBox(height: Dimensions.height10 / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _reason,
                      isExpanded: true,
                      hint: Text(
                        'Select a reason',
                        style: TextStyle(
                          color: context.colors.textTertiary,
                          fontSize: Dimensions.font16 * 0.85,
                        ),
                      ),
                      style: FormTextStyles.value(context),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: context.colors.textSecondary,
                      ),
                      items: _reasons
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _reason = v);
                        markDirty();
                      },
                    ),
                  ),
                  const FormDivider(),
                  SizedBox(height: Dimensions.height15),
                  Text('Description', style: FormTextStyles.label()),
                  TextField(
                    controller: _descriptionController,
                    maxLength: 500,
                    maxLines: 3,
                    style: FormTextStyles.value(context),
                    decoration: InputDecoration(
                      hintText: 'Max 500 Characters',
                      hintStyle: TextStyle(color: context.colors.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                      counterText: '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              if (_lineItems.isNotEmpty) ...[
                ..._lineItems.map(
                  (item) => AdjustmentLineItemCard(
                    item: item,
                    onTap: () => _editLineItem(item),
                    onRemove: () => _removeLineItem(item.id),
                  ),
                ),
                SizedBox(height: Dimensions.height10 / 2),
              ],
              AddLineItemButton(onPressed: _addLineItem),
              SizedBox(height: Dimensions.height15),
              FormCard(
                children: [
                  Row(
                    children: [
                      Text('Attachments', style: FormTextStyles.label()),
                      if (_attachments.isNotEmpty) ...[
                        SizedBox(width: Dimensions.width10 / 2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10 * 0.6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${_attachments.length}',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.7,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _showAttachmentsDialog,
                    child: DashedBorder(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file_outlined,
                              color: AppColors.primary,
                              size: Dimensions.iconSize24 - 4,
                            ),
                            SizedBox(width: Dimensions.width10),
                            Text(
                              _attachments.isEmpty
                                  ? 'Upload File'
                                  : '${_attachments.length} file(s) attached',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.85,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
