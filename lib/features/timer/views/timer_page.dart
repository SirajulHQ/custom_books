import 'dart:async';

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final TextEditingController _notesController = TextEditingController();

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _running = false;

  String? _selectedProject;
  String? _selectedTask;

  static const List<String> _projectOptions = [
    'Website Redesign',
    'Mobile App Development',
    'Brand Identity',
    'SEO Audit',
  ];

  static const List<String> _taskOptions = [
    'Homepage layout',
    'API integration',
    'Design review',
    'Keyword research',
    'Bug fixing',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsed += const Duration(seconds: 1));
      });
      setState(() => _running = true);
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    final hadTime = _elapsed.inSeconds > 0;
    setState(() {
      _running = false;
      _elapsed = Duration.zero;
      _notesController.clear();
    });
    if (hadTime) {
      ToastificationHelper.showSuccess(context, 'Time entry saved');
    }
  }

  void _openSelector({
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font20 * 0.85,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                ...options.map(
                  (option) => InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height10,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.8,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'timer'),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Timer',
            subtitle: 'Track your time',
            leadingType: AppBarLeadingType.menu,
            actions: [
              AppBarIconButton(
                icon: Icons.history_rounded,
                onPressed: () => ToastificationHelper.showSuccess(
                  context,
                  'History coming soon',
                ),
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height20),
            // Circular timer display
            Container(
              width: Dimensions.height45 * 4,
              height: Dimensions.height45 * 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.card,
                border: Border.all(
                  color: _running ? Appcolors.primary : context.colors.border,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.primary.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: Dimensions.iconSize24,
                    color: Appcolors.primary,
                  ),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      fontSize: Dimensions.font26 * 1.1,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Text(
                    _running ? 'Running' : 'Paused',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.7,
                      fontWeight: FontWeight.w600,
                      color: _running
                          ? Appcolors.success
                          : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30),
            // Start/Pause + Stop buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: OutlinedButton.icon(
                      onPressed: _toggleTimer,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Appcolors.primary,
                        side: const BorderSide(color: Appcolors.primary, width: 1.5),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                      ),
                      icon: Icon(
                        _running
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        _running ? 'Pause' : 'Start',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _stopTimer,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Appcolors.error,
                      side: const BorderSide(color: Appcolors.error),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stop_rounded),
                        SizedBox(width: Dimensions.width10 / 2),
                        Text(
                          'Stop',
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height30),
            _selectorCard(
              label: 'Project',
              value: _selectedProject,
              icon: Icons.folder_open_rounded,
              onTap: () => _openSelector(
                title: 'Select Project',
                options: _projectOptions,
                onSelected: (v) => setState(() => _selectedProject = v),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            _selectorCard(
              label: 'Task',
              value: _selectedTask,
              icon: Icons.checklist_rounded,
              onTap: () => _openSelector(
                title: 'Select Task',
                options: _taskOptions,
                onSelected: (v) => setState(() => _selectedTask = v),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            // Notes field
            Container(
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                border: Border.all(color: context.colors.border),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height10 / 2,
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                minLines: 2,
                style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                decoration: InputDecoration(
                  hintText: 'Notes',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.notes_rounded,
                    color: context.colors.textTertiary,
                    size: Dimensions.iconSize16 + 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _selectorCard({
    required String label,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: Dimensions.height45 * 0.78,
              height: Dimensions.height45 * 0.78,
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                icon,
                color: Appcolors.primary,
                size: Dimensions.iconSize24 - 4,
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
                      fontSize: Dimensions.font16 * 0.65,
                      color: context.colors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 3),
                  Text(
                    value ?? 'Select $label',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.85,
                      fontWeight: FontWeight.w600,
                      color: value == null
                          ? context.colors.textTertiary
                          : context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
