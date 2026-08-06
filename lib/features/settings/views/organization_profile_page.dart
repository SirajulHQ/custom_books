import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/app_logger.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:flutter/material.dart';

class OrganizationProfilePage extends StatefulWidget {
  const OrganizationProfilePage({super.key});

  @override
  State<OrganizationProfilePage> createState() =>
      _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  final _orgNameController = TextEditingController();
  final _portalNameController = TextEditingController();
  final _street1Controller = TextEditingController();
  final _street2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _faxController = TextEditingController();
  final _websiteController = TextEditingController();
  final _companyIdController = TextEditingController();

  String? _industry;
  String? _organizationLocation;
  String? _state;
  String? _fiscalYear;
  String? _language;
  String? _timeZone;
  String? _dateFormat;

  bool _updateAddressInTransactions = false;
  bool _addDifferentAddress = false;

  static const List<String> _industries = [
    'Food, Groceries & Beverages',
    'Technology',
    'Healthcare',
    'Education',
    'Retail',
    'Manufacturing',
    'Services',
    'Other',
  ];

  static const List<String> _locations = [
    'United Arab Emirates',
    'India',
    'Saudi Arabia',
    'United States',
    'United Kingdom',
    'Other',
  ];

  static const List<String> _states = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Fujairah',
    'Ras Al Khaimah',
    'Umm Al Quwain',
  ];

  static const List<String> _fiscalYears = [
    'January - December',
    'April - March',
    'July - June',
    'October - September',
  ];

  static const List<String> _languages = [
    'English',
    'Arabic',
    'Hindi',
    'French',
    'Spanish',
  ];

  // ignore: unused_field
  static const List<String> _timeZones = [
    '(GMT 4:00) Gulf Standard Time (Asia/Dubai)',
    '(GMT 5:30) India Standard Time (Asia/Kolkata)',
    '(GMT 3:00) Arabia Standard Time (Asia/Riyadh)',
    '(GMT 0:00) UTC',
    '(GMT -5:00) Eastern Standard Time (US/Eastern)',
  ];

  static const List<String> _dateFormats = [
    'dd MMM yyyy [ 06 Aug 2026 ]',
    'MM/dd/yyyy [ 08/06/2026 ]',
    'dd/MM/yyyy [ 06/08/2026 ]',
    'yyyy-MM-dd [ 2026-08-06 ]',
  ];

  @override
  void initState() {
    super.initState();
    appLog(
      '🏢 OrganizationProfilePage initialized',
      name: 'OrganizationProfile',
    );
    // Pre-fill with sample data
    _orgNameController.text = 'Own Store';
    _portalNameController.text = 'store926602888';
    _industry = 'Food, Groceries & Beverages';
    _organizationLocation = 'United Arab Emirates';
    _state = 'Dubai';
    _phoneController.text = '9567484826';
    _fiscalYear = 'January - December';
    _language = 'English';
    _timeZone = '(GMT 4:00) Gulf Standard Time (Asia/Dubai)';
    _dateFormat = 'dd MMM yyyy [ 06 Aug 2026 ]';
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _portalNameController.dispose();
    _street1Controller.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _faxController.dispose();
    _websiteController.dispose();
    _companyIdController.dispose();
    super.dispose();
  }

  void _save() {
    appLog('💾 Save Organization Profile', name: 'OrganizationProfile');
    Navigator.pop(context);
  }

  Future<String?> _selectFromSheet(
    String title,
    List<String> options,
    String? current,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: context.colors.card,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: options
                    .map(
                      (option) => ListTile(
                        title: Text(
                          option,
                          style: TextStyle(
                            color: option == current
                                ? Appcolors.primary
                                : context.colors.textPrimary,
                            fontWeight: option == current
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: option == current
                            ? Icon(
                                Icons.check_rounded,
                                color: Appcolors.primary,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, option),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
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
              title: 'Organization Profile',
              leadingType: AppBarLeadingType.back,
              actions: [
                AppBarElevatedButton(label: 'SAVE', onPressed: _save),
                SizedBox(width: Dimensions.width20),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Organization ID
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height10,
                        horizontal: Dimensions.width10,
                      ),
                      child: Text(
                        'Organization ID: 926602888',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    // Logo & Basic Info Card
                    FormCard(
                      children: [
                        // Logo Upload Area
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(Dimensions.width15),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.colors.textTertiary,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15 / 2,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: _DashedBorderPainter(
                                    color: context.colors.textTertiary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Upload your\nlogo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.75,
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.width15),
                              Expanded(
                                child: Text(
                                  'This logo will appear on transactions and email notifications.',
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.8,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Organization Name
                        const RequiredLabel(text: 'Organization Name'),
                        SizedBox(height: Dimensions.height10 / 2),
                        TextField(
                          controller: _orgNameController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Portal Name
                        Row(
                          children: [
                            const RequiredLabel(text: 'Portal Name'),
                            SizedBox(width: Dimensions.width10 / 2),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: Dimensions.iconSize16,
                                color: context.colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _portalNameController,
                                style: FormTextStyles.value(context),
                                decoration: _underlineDecoration(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.settings_outlined,
                                size: Dimensions.iconSize24,
                                color: context.colors.textSecondary,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Dimensions.height10 / 2,
                          ),
                          child: Text(
                            'https://books.zoho.com/portal/store926602888',
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.75,
                              color: Appcolors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Industry
                        Row(
                          children: [
                            Text('Industry', style: FormTextStyles.label()),
                            SizedBox(width: Dimensions.width10 / 2),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: Dimensions.iconSize16,
                                color: context.colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _industry,
                          hint: 'Select Industry',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select Industry',
                              _industries,
                              _industry,
                            );
                            if (selected != null) {
                              setState(() => _industry = selected);
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Location & Address Card
                    FormCard(
                      children: [
                        const RequiredLabel(text: 'Organization Location'),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _organizationLocation,
                          hint: 'Select Location',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select Location',
                              _locations,
                              _organizationLocation,
                            );
                            if (selected != null) {
                              setState(() => _organizationLocation = selected);
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.height20),

                        Row(
                          children: [
                            Text(
                              'Organization Address',
                              style: FormTextStyles.label(),
                            ),
                            SizedBox(width: Dimensions.width10 / 2),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: Dimensions.iconSize16,
                                color: context.colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10),

                        // Street 1
                        TextField(
                          controller: _street1Controller,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Street 1'),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Street 2
                        TextField(
                          controller: _street2Controller,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Street 2'),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // City
                        TextField(
                          controller: _cityController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'City'),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // State
                        _selectorField(
                          value: _state,
                          hint: 'State',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select State',
                              _states,
                              _state,
                            );
                            if (selected != null) {
                              setState(() => _state = selected);
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Zip Code
                        TextField(
                          controller: _zipCodeController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Zip Code'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Phone
                        TextField(
                          controller: _phoneController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Phone'),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Fax
                        TextField(
                          controller: _faxController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Fax'),
                        ),
                        SizedBox(height: Dimensions.height15),

                        // Website
                        TextField(
                          controller: _websiteController,
                          style: FormTextStyles.value(context),
                          decoration: _underlineDecoration(hint: 'Website'),
                          keyboardType: TextInputType.url,
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Checkboxes
                        _buildCheckboxTile(
                          'Update the address in all previous transactions.',
                          _updateAddressInTransactions,
                          (val) => setState(
                            () => _updateAddressInTransactions = val ?? false,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        _buildCheckboxTile(
                          'Would you like to add a different address for payment stubs?',
                          _addDifferentAddress,
                          (val) => setState(
                            () => _addDifferentAddress = val ?? false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height15),

                    // Fiscal Year & Locale Card
                    FormCard(
                      children: [
                        Text('Fiscal Year', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _fiscalYear,
                          hint: 'Select Fiscal Year',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select Fiscal Year',
                              _fiscalYears,
                              _fiscalYear,
                            );
                            if (selected != null) {
                              setState(() => _fiscalYear = selected);
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.height20),

                        Text('Language', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _language,
                          hint: 'Select Language',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select Language',
                              _languages,
                              _language,
                            );
                            if (selected != null) {
                              setState(() => _language = selected);
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.height20),

                        Text('Time Zone', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        Text(
                          _timeZone ?? 'Select Time Zone',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            color: _timeZone == null
                                ? context.colors.textTertiary
                                : context.colors.textPrimary,
                          ),
                        ),
                        Divider(color: context.colors.border),
                        SizedBox(height: Dimensions.height15),

                        Text('Date Format', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        _selectorField(
                          value: _dateFormat,
                          hint: 'Select Date Format',
                          onTap: () async {
                            final selected = await _selectFromSheet(
                              'Select Date Format',
                              _dateFormats,
                              _dateFormat,
                            );
                            if (selected != null) {
                              setState(() => _dateFormat = selected);
                            }
                          },
                        ),
                        SizedBox(height: Dimensions.height20),

                        Text('Company ID', style: FormTextStyles.label()),
                        SizedBox(height: Dimensions.height10 / 2),
                        Row(
                          children: [
                            Text(
                              'Company ID :',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Expanded(
                              child: TextField(
                                controller: _companyIdController,
                                style: FormTextStyles.value(context),
                                decoration: _underlineDecoration(),
                              ),
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
    );
  }

  Widget _buildCheckboxTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Appcolors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _underlineDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.colors.textTertiary),
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

  Widget _selectorField({
    required String? value,
    required String hint,
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
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.9,
                  color: value == null
                      ? context.colors.textTertiary
                      : context.colors.textPrimary,
                  fontWeight: value == null
                      ? FontWeight.normal
                      : FontWeight.w500,
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
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(6),
        ),
      );

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
