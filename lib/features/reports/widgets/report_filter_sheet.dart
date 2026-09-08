import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/reports/models/report_type.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class ReportFilterSheet extends StatefulWidget {
  final ReportType reportType;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime asOfDate;
  final String reportBasis;
  final String filterAccounts;
  final String compareWith;
  final void Function(
    DateTime startDate,
    DateTime endDate,
    DateTime asOfDate,
    String reportBasis,
    String filterAccounts,
    String compareWith,
  )
  onApply;

  const ReportFilterSheet({
    super.key,
    required this.reportType,
    required this.startDate,
    required this.endDate,
    required this.asOfDate,
    required this.reportBasis,
    required this.filterAccounts,
    required this.compareWith,
    required this.onApply,
  });

  @override
  State<ReportFilterSheet> createState() => _ReportFilterSheetState();
}

class _ReportFilterSheetState extends State<ReportFilterSheet> {
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _asOfDate;
  late String _reportBasis;
  late String _filterAccounts;
  late String _compareWith;
  String _datePreset = 'This Month';
  String _asOfPreset = 'Today';

  static const List<String> _dateRangePresets = [
    'Today',
    'This Week',
    'This Month',
    'This Quarter',
    'This Year',
    'Previous Week',
    'Previous Month',
    'Previous Quarter',
    'Previous Year',
    'Custom',
  ];

  static const List<String> _asOfPresets = [
    'Today',
    'End of this Week',
    'End of this Month',
    'End of Previous Month',
    'End of this Quarter',
    'End of this Year',
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _asOfDate = widget.asOfDate;
    _reportBasis = widget.reportBasis;
    _filterAccounts = widget.filterAccounts;
    _compareWith = widget.compareWith;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(
              ctx,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _datePreset = 'Custom';
      });
    }
  }

  Future<void> _pickAsOfDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _asOfDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(
              ctx,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _asOfDate = picked;
        _asOfPreset = 'Custom';
      });
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _quarterStart(DateTime ref) {
    final startMonth = ((ref.month - 1) ~/ 3) * 3 + 1;
    return DateTime(ref.year, startMonth, 1);
  }

  void _applyDateRangePreset(String preset) {
    final now = _dateOnly(DateTime.now());
    DateTime start;
    DateTime end;

    switch (preset) {
      case 'Today':
        start = now;
        end = now;
        break;
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = start.add(const Duration(days: 6));
        break;
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0);
        break;
      case 'This Quarter':
        start = _quarterStart(now);
        end = DateTime(start.year, start.month + 3, 0);
        break;
      case 'This Year':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        break;
      case 'Previous Week':
        final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
        start = thisWeekStart.subtract(const Duration(days: 7));
        end = thisWeekStart.subtract(const Duration(days: 1));
        break;
      case 'Previous Month':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0);
        break;
      case 'Previous Quarter':
        final thisQuarterStart = _quarterStart(now);
        start = DateTime(thisQuarterStart.year, thisQuarterStart.month - 3, 1);
        end = DateTime(thisQuarterStart.year, thisQuarterStart.month, 0);
        break;
      case 'Previous Year':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        break;
      case 'Custom':
      default:
        setState(() => _datePreset = 'Custom');
        return;
    }

    setState(() {
      _datePreset = preset;
      _startDate = start;
      _endDate = end;
    });
  }

  void _applyAsOfPreset(String preset) {
    final now = _dateOnly(DateTime.now());
    DateTime asOf;

    switch (preset) {
      case 'Today':
        asOf = now;
        break;
      case 'End of this Week':
        asOf = now
            .subtract(Duration(days: now.weekday - 1))
            .add(const Duration(days: 6));
        break;
      case 'End of this Month':
        asOf = DateTime(now.year, now.month + 1, 0);
        break;
      case 'End of Previous Month':
        asOf = DateTime(now.year, now.month, 0);
        break;
      case 'End of this Quarter':
        final qStart = _quarterStart(now);
        asOf = DateTime(qStart.year, qStart.month + 3, 0);
        break;
      case 'End of this Year':
        asOf = DateTime(now.year, 12, 31);
        break;
      default:
        return;
    }

    setState(() {
      _asOfPreset = preset;
      _asOfDate = asOf;
    });
  }

  Future<void> _showPresetPicker({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Dimensions.height10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              ...options.map((option) {
                final isSelected = option == selected;
                return InkWell(
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onSelected(option);
                  },
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height15 * 0.7,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: Dimensions.iconSize24 * 0.9,
                          color: isSelected
                              ? AppColors.primary
                              : context.colors.textTertiary,
                        ),
                        SizedBox(width: Dimensions.width15),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : context.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAsOf = widget.reportType.dateMode == ReportDateMode.asOf;
    final isFinancial = widget.reportType.category == ReportCategory.financial;

    return Container(
      margin: EdgeInsets.all(Dimensions.width15),
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: context.colors.textSecondary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Date selection
            if (isAsOf) ...[
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('As of Date', style: FormTextStyles.sectionLabel(context))),
              _dropdownTile(
                icon: Icons.calendar_today_rounded,
                value: _asOfPreset,
                onTap: () => _showPresetPicker(
                  title: 'As of Date',
                  options: _asOfPresets,
                  selected: _asOfPreset,
                  onSelected: _applyAsOfPreset,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('Report Date', style: FormTextStyles.sectionLabel(context))),
              InkWell(
                onTap: _pickAsOfDate,
                child: _dateBox(formatDate(_asOfDate)),
              ),
            ] else ...[
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('Date Range', style: FormTextStyles.sectionLabel(context))),
              _dropdownTile(
                icon: Icons.calendar_today_rounded,
                value: _datePreset,
                onTap: () => _showPresetPicker(
                  title: 'Date Range',
                  options: _dateRangePresets,
                  selected: _datePreset,
                  onSelected: _applyDateRangePreset,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isStart: true),
                      child: _dateBox(formatDate(_startDate)),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isStart: false),
                      child: _dateBox(formatDate(_endDate)),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: Dimensions.height20),

            // Report Basis (financial only)
            if (isFinancial) ...[
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('Report Basis', style: FormTextStyles.sectionLabel(context))),
              _buildDropdown(
                value: _reportBasis,
                items: ['Cash', 'Accrual'],
                onChanged: (v) => setState(() => _reportBasis = v!),
              ),
              SizedBox(height: Dimensions.height15),
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('Filter Accounts', style: FormTextStyles.sectionLabel(context))),
              _buildDropdown(
                value: _filterAccounts,
                items: ['Accounts Without Zero Balance', 'All Accounts'],
                onChanged: (v) => setState(() => _filterAccounts = v!),
              ),
              SizedBox(height: Dimensions.height20),
              Divider(color: context.colors.border),
              SizedBox(height: Dimensions.height10),
              // Compare section
              Text(
                'COMPARE',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Compare Based on Period/Year ▼',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              Padding(padding: EdgeInsets.only(bottom: Dimensions.height10 / 2), child: Text('Compare With', style: FormTextStyles.sectionLabel(context))),
              _buildDropdown(
                value: _compareWith,
                items: ['None', 'Previous Period', 'Previous Year'],
                onChanged: (v) => setState(() => _compareWith = v!),
              ),
            ],

            SizedBox(height: Dimensions.height30),

            // Run Report button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _startDate,
                    _endDate,
                    _asOfDate,
                    _reportBasis,
                    _filterAccounts,
                    _compareWith,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                ),
                child: Text(
                  'Run Report',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }


  Widget _dateBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }

  Widget _dropdownTile({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16,
              color: context.colors.textSecondary,
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              value,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.colors.textSecondary,
          ),
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            color: context.colors.textPrimary,
          ),
          dropdownColor: context.colors.card,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
