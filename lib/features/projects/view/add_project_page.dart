import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/features/projects/models/project_model.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:flutter/material.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _projectNameController = TextEditingController();
  final _customerController = TextEditingController();
  final _rateController = TextEditingController();
  final _budgetHoursController = TextEditingController();

  BillingMethod _billingMethod = BillingMethod.values.first;

  static const List<String> _customers = [
    'Nandhu',
    'Parthiv Ajith',
    'Amal',
    'Tech Geum',
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _customerController.dispose();
    _rateController.dispose();
    _budgetHoursController.dispose();
    super.dispose();
  }

  Future<void> _selectCustomer() async {
    final selected = await showModalBottomSheet<String>(
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
                'Select Customer',
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
                children: [
                  ..._customers.map(
                    (name) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Appcolors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Appcolors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(color: context.colors.textPrimary),
                      ),
                      onTap: () => Navigator.pop(context, name),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _customerController.text = selected);
    }
  }

  Future<void> _selectBillingMethod() async {
    final selected = await showModalBottomSheet<BillingMethod>(
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
                'Billing Method',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...BillingMethod.values.map(
              (method) => ListTile(
                title: Text(
                  method.label,
                  style: TextStyle(
                    color: method == _billingMethod
                        ? Appcolors.primary
                        : context.colors.textPrimary,
                    fontWeight: method == _billingMethod
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: method == _billingMethod
                    ? const Icon(Icons.check_rounded, color: Appcolors.primary)
                    : null,
                onTap: () => Navigator.pop(context, method),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _billingMethod = selected);
    }
  }

  void _saveProject() {
    if (_projectNameController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Project Name.');
      return;
    }
    if (_customerController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Customer.');
      return;
    }

    final newProject = ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectName: _projectNameController.text.trim(),
      customerName: _customerController.text.trim(),
      status: ProjectStatus.active,
      billingMethod: _billingMethod,
      rate: double.tryParse(_rateController.text.trim()) ?? 0,
      budgetHours: double.tryParse(_budgetHoursController.text.trim()) ?? 0,
      loggedHours: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, newProject);
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'New Project',
        backgroundColor: context.colors.card,
        actions: [
          TextButton(
            onPressed: _saveProject,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: Appcolors.primary,
                fontWeight: FontWeight.w800,
                fontSize: Dimensions.font16 * 0.75,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width15),
        child: Column(
          children: [
            FormCard(
              children: [
                // Project Name *
                const RequiredLabel(text: 'Project Name'),
                SizedBox(height: Dimensions.height10 / 2),
                TextField(
                  controller: _projectNameController,
                  style: FormTextStyles.value(context),
                  decoration: InputDecoration(
                    hintText: 'Enter project name',
                    hintStyle: TextStyle(color: context.colors.textTertiary),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Appcolors.primary),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // Customer Name *
                const RequiredLabel(text: 'Customer Name'),
                SizedBox(height: Dimensions.height10 / 2),
                InkWell(
                  onTap: _selectCustomer,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _customerController.text.isEmpty
                                ? 'Select a Customer'
                                : _customerController.text,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.9,
                              color: _customerController.text.isEmpty
                                  ? context.colors.textTertiary
                                  : context.colors.textPrimary,
                              fontWeight: _customerController.text.isEmpty
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

                // Billing Method
                Text('Billing Method', style: FormTextStyles.label()),
                SizedBox(height: Dimensions.height10 / 2),
                InkWell(
                  onTap: _selectBillingMethod,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: context.colors.border),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _billingMethod.label,
                          style: FormTextStyles.value(context),
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
              ],
            ),
            SizedBox(height: Dimensions.height15),

            FormCard(
              children: [
                // Rate (AED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rate (AED)', style: FormTextStyles.label()),
                    FormNumberField(
                      controller: _rateController,
                      hint: '0.00',
                      prefix: 'AED',
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height20),

                // Budget Hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Budget Hours', style: FormTextStyles.label()),
                    FormNumberField(
                      controller: _budgetHoursController,
                      hint: '0',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
