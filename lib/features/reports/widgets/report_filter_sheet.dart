import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/reports/models/report_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        _datePreset = 'Custom';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final fmt = DateFormat('dd MMM yyyy');
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
              _label('As of Date'),
              _dropdownTile(
                icon: Icons.calendar_today_rounded,
                value: 'Today',
                onTap: () {},
              ),
              SizedBox(height: Dimensions.height10),
              _label('Report Date'),
              InkWell(
                onTap: _pickAsOfDate,
                child: _dateBox(fmt.format(_asOfDate)),
              ),
            ] else ...[
              _label('Date Range'),
              _dropdownTile(
                icon: Icons.calendar_today_rounded,
                value: _datePreset,
                onTap: () {},
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isStart: true),
                      child: _dateBox(fmt.format(_startDate)),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(isStart: false),
                      child: _dateBox(fmt.format(_endDate)),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: Dimensions.height20),

            // Report Basis (financial only)
            if (isFinancial) ...[
              _label('Report Basis'),
              _buildDropdown(
                value: _reportBasis,
                items: ['Cash', 'Accrual'],
                onChanged: (v) => setState(() => _reportBasis = v!),
              ),
              SizedBox(height: Dimensions.height15),
              _label('Filter Accounts'),
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
              _label('Compare With'),
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

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w600,
          color: context.colors.textPrimary,
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
