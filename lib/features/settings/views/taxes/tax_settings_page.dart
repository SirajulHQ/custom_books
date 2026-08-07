import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class TaxSettingsPage extends StatefulWidget {
  const TaxSettingsPage({super.key});

  @override
  State<TaxSettingsPage> createState() => _TaxSettingsPageState();
}

class _TaxSettingsPageState extends State<TaxSettingsPage> {
  bool _isRegistered = true;
  final TextEditingController _trnController = TextEditingController(
    text: '100123456700003',
  );
  bool _enableInternationalTrade = false;
  DateTime _vatRegistrationDate = DateTime(2018, 1, 1);
  DateTime _firstTaxReturnDate = DateTime(2018, 1, 1);
  String _reportingPeriod = 'Custom';

  static const List<String> _reportingPeriodOptions = [
    'Monthly',
    'Quarterly',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    appLog('⚙️ TaxSettingsPage initialized', name: 'TaxSettings');
  }

  @override
  void dispose() {
    _trnController.dispose();
    super.dispose();
  }

  void _save() {
    appLog('💾 Save Tax Settings', name: 'TaxSettings');
    Navigator.pop(context);
  }

  Future<void> _selectDate({
    required DateTime current,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: Appcolors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  Future<void> _selectReportingPeriod() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                'Reporting Period',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._reportingPeriodOptions.map(
              (option) => ListTile(
                title: Text(option),
                trailing: option == _reportingPeriod
                    ? Icon(Icons.check_rounded, color: Appcolors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, option),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => _reportingPeriod = selected);
    }
  }

  String _formatDate(DateTime date) {
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'Tax Settings',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width15),
                child: Column(
                  children: [
                    // Tax Registration Section
                    FormCard(
                      children: [
                        Text(
                          'Tax Registration',
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Is your business registered for VAT?',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isRegistered,
                              onChanged: (val) =>
                                  setState(() => _isRegistered = val),
                              activeColor: Appcolors.primary,
                            ),
                          ],
                        ),
                        if (_isRegistered) ...[
                          SizedBox(height: Dimensions.height15),
                          const RequiredLabel(text: 'Tax Registration Number'),
                          SizedBox(height: Dimensions.height10 / 2),
                          Row(
                            children: [
                              Text(
                                'TRN',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              SizedBox(width: Dimensions.width20),
                              Expanded(
                                child: TextField(
                                  controller: _trnController,
                                  style: FormTextStyles.value(context),
                                  keyboardType: TextInputType.number,
                                  decoration: _underlineDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: Dimensions.height15),

                    // International Trade Section
                    FormCard(
                      children: [
                        Text(
                          'International Trade',
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Enable trade with contacts outside United Arab Emirates',
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.9,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ),
                            Switch(
                              value: _enableInternationalTrade,
                              onChanged: (val) => setState(
                                () => _enableInternationalTrade = val,
                              ),
                              activeColor: Appcolors.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10),
                        Text(
                          'NOTE: Enable this option, if you are doing business with other GCC / Non-GCC countries, also for reverse charge handling.',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.75,
                            color: context.colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // VAT Registration Date
                        const RequiredLabel(text: 'VAT Registration Date'),
                        SizedBox(height: Dimensions.height10 / 2),
                        _buildDateField(
                          value: _vatRegistrationDate,
                          onTap: () => _selectDate(
                            current: _vatRegistrationDate,
                            onSelected: (date) =>
                                setState(() => _vatRegistrationDate = date),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Generate First Tax Return From
                        const RequiredLabel(
                          text: 'Generate First Tax Return From',
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        _buildDateField(
                          value: _firstTaxReturnDate,
                          onTap: () => _selectDate(
                            current: _firstTaxReturnDate,
                            onSelected: (date) =>
                                setState(() => _firstTaxReturnDate = date),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Reporting Period
                        Text('Reporting Period', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _buildSelectorField(
                          value: _reportingPeriod,
                          onTap: _selectReportingPeriod,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime value,
    required VoidCallback onTap,
  }) {
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
            Text(
              _formatDate(value),
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: Dimensions.iconSize24 - 4,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorField({
    required String value,
    required VoidCallback onTap,
  }) {
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
            Text(
              value,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w500,
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
    );
  }

  InputDecoration _underlineDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Appcolors.primary),
      ),
    );
  }
}
