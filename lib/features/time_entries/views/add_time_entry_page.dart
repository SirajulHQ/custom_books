import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/form_widgets.dart';
import 'package:custom_books/core/widgets/unsaved_changes_dialog.dart';
import 'package:custom_books/features/time_entries/models/time_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';

class AddTimeEntryPage extends StatefulWidget {
  final TimeEntryModel? existing;

  const AddTimeEntryPage({super.key, this.existing});

  @override
  State<AddTimeEntryPage> createState() => _AddTimeEntryPageState();
}

class _AddTimeEntryPageState extends State<AddTimeEntryPage>
    with UnsavedChangesMixin {
  final _taskNameController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _notesController = TextEditingController();

  String? _project;
  String _userName = 'Own Store';
  DateTime _logDate = DateTime.now();
  bool _isBillable = true;

  static const List<String> _projects = [
    'Website Redesign',
    'Mobile App',
    'Branding',
  ];

  static const List<String> _users = ['Own Store', 'Parthiv P', 'Aarav Menon'];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _project = existing.projectName;
      _taskNameController.text = existing.taskName;
      _userName = existing.userName;
      _logDate = existing.logDate;
      _hoursController.text = (existing.durationMinutes ~/ 60).toString();
      _minutesController.text = (existing.durationMinutes % 60).toString();
      _isBillable = existing.isBillable;
      _notesController.text = existing.notes;
    }
    _taskNameController.addListener(markDirty);
    _hoursController.addListener(markDirty);
    _minutesController.addListener(markDirty);
    _notesController.addListener(markDirty);
  }

  @override
  void dispose() {
    _taskNameController.removeListener(markDirty);
    _hoursController.removeListener(markDirty);
    _minutesController.removeListener(markDirty);
    _notesController.removeListener(markDirty);
    _taskNameController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _logDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _logDate = picked);
    }
  }

  Future<void> _selectProject() async {
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
                'Select Project',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._projects.map(
              (name) => ListTile(
                title: Text(
                  name,
                  style: TextStyle(
                    color: name == _project
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: name == _project
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: name == _project
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, name),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _project = selected);
    }
  }

  Future<void> _selectUser() async {
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
                'Select User',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.1,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ..._users.map(
              (name) => ListTile(
                title: Text(
                  name,
                  style: TextStyle(
                    color: name == _userName
                        ? AppColors.primary
                        : context.colors.textPrimary,
                    fontWeight: name == _userName
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: name == _userName
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, name),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _userName = selected);
    }
  }

  void _saveEntry() {
    if (_project == null || _project!.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please select a Project.');
      return;
    }
    if (_taskNameController.text.trim().isEmpty) {
      ToastificationHelper.showWarning(context, 'Please enter a Task Name.');
      return;
    }

    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;

    final newEntry = TimeEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectName: _project!.trim(),
      taskName: _taskNameController.text.trim(),
      userName: _userName,
      logDate: _logDate,
      durationMinutes: hours * 60 + minutes,
      isBillable: _isBillable,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    markClean();
    Navigator.pop(context, newEntry);
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
                title: widget.existing == null
                    ? 'New Time Entry'
                    : 'Edit Time Entry',
                leadingType: AppBarLeadingType.back,
                onLeadingPressed: () => onPopInvokedWithResult(false, null),
                actions: [
                  AppBarElevatedButton(label: 'SAVE', onPressed: _saveEntry),
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
                          // Project *
                          const RequiredLabel(text: 'Project'),
                          SizedBox(height: Dimensions.height10 / 2),
                          InkWell(
                            onTap: _selectProject,
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
                                      _project ?? 'Select a Project',
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 0.9,
                                        color: _project == null
                                            ? context.colors.textTertiary
                                            : context.colors.textPrimary,
                                        fontWeight: _project == null
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

                          // Task Name *
                          const RequiredLabel(text: 'Task Name'),
                          SizedBox(height: Dimensions.height10 / 2),
                          TextField(
                            controller: _taskNameController,
                            style: FormTextStyles.value(context),
                            decoration: InputDecoration(
                              hintText: 'Enter task name',
                              hintStyle: TextStyle(
                                color: context.colors.textTertiary,
                              ),
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

                          // User
                          Text('User', style: FormTextStyles.label()),
                          SizedBox(height: Dimensions.height10 / 2),
                          InkWell(
                            onTap: _selectUser,
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
                                  Text(
                                    _userName,
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
                          SizedBox(height: Dimensions.height20),

                          // Log Date *
                          const RequiredLabel(text: 'Log Date'),
                          SizedBox(height: Dimensions.height10 / 2),
                          InkWell(
                            onTap: _pickDate,
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
                                  Text(
                                    formatDate(_logDate),
                                    style: FormTextStyles.value(context),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: Dimensions.iconSize24 * 0.85,
                                    color: context.colors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Duration
                      FormCard(
                        children: [
                          Text('Duration', style: FormTextStyles.label()),
                          SizedBox(height: Dimensions.height15),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: FormTextStyles.label(),
                                    ),
                                    SizedBox(height: Dimensions.height10 / 2),
                                    FormNumberField(
                                      controller: _hoursController,
                                      hint: '0',
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: Dimensions.width15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Minutes',
                                      style: FormTextStyles.label(),
                                    ),
                                    SizedBox(height: Dimensions.height10 / 2),
                                    FormNumberField(
                                      controller: _minutesController,
                                      hint: '0',
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Billable radios
                      FormCard(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Billable', style: FormTextStyles.label()),
                              RadioGroup<bool>(
                                groupValue: _isBillable,
                                onChanged: (val) =>
                                    setState(() => _isBillable = val!),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _isBillable = true),
                                      child: Row(
                                        children: [
                                          Radio<bool>(value: true),
                                          Text(
                                            'Billable',
                                            style: TextStyle(
                                              fontSize: Dimensions.font16 * 0.9,
                                              fontWeight: FontWeight.w600,
                                              color: context.colors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width15),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _isBillable = false),
                                      child: Row(
                                        children: [
                                          Radio<bool>(value: false),
                                          Text(
                                            'Non-billable',
                                            style: TextStyle(
                                              fontSize: Dimensions.font16 * 0.9,
                                              fontWeight: FontWeight.w600,
                                              color: context.colors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height15),

                      // Notes
                      FormCard(
                        children: [
                          Text('Notes', style: FormTextStyles.label()),
                          SizedBox(height: Dimensions.height10 / 2),
                          TextField(
                            controller: _notesController,
                            maxLines: 4,
                            style: FormTextStyles.value(context),
                            decoration: InputDecoration(
                              hintText: 'Add notes',
                              hintStyle: TextStyle(
                                color: context.colors.textTertiary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 / 2,
                                ),
                                borderSide: BorderSide(
                                  color: context.colors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 / 2,
                                ),
                                borderSide: BorderSide(
                                  color: context.colors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15 / 2,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
