import 'dart:async';

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/views/associate_project_page.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:custom_books/features/time_entries/views/add_time_entry_page.dart';
import 'package:flutter/material.dart';

class ProjectTimerCardWidget extends StatefulWidget {
  const ProjectTimerCardWidget({super.key});

  @override
  State<ProjectTimerCardWidget> createState() => _ProjectTimerCardWidgetState();
}

class _ProjectTimerCardWidgetState extends State<ProjectTimerCardWidget> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  String? _associatedProject;

  String get _formattedTime {
    final hours = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resumeTimer() {
    setState(() => _isPaused = false);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _elapsedSeconds = 0;
      _associatedProject = null;
    });
  }

  void _discardTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _elapsedSeconds = 0;
      _associatedProject = null;
    });
  }

  void _openAssociateProjectPage() async {
    // Pause the local timer while on the associate page
    _timer?.cancel();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AssociateProjectPage(initialElapsedSeconds: _elapsedSeconds),
      ),
    );
    if (result == true) {
      // User tapped Stop Timer on the page
      _stopTimer();
    } else {
      // User dismissed — resume timer
      if (_isRunning && !_isPaused) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() => _elapsedSeconds++);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          CardTitle(title: 'Project Summary', icon: Icons.timer_outlined),
          SizedBox(height: Dimensions.height15),

          // Timer display area
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height20,
              horizontal: Dimensions.width15,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Column(
              children: [
                // Timer display
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: Dimensions.font26 * 1.4,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: Dimensions.height10 * 0.5),

                // Associate Project label
                GestureDetector(
                  onTap: _isRunning ? _openAssociateProjectPage : null,
                  child: Text(
                    _associatedProject ?? 'Associate Project',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),

                // Action buttons row
                if (!_isRunning)
                  // Not running: show Log Time + Start Timer
                  Row(
                    children: [
                      Expanded(
                        child: _OutlineActionButton(
                          label: 'Log Time',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddTimeEntryPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Expanded(
                        child: _FilledActionButton(
                          label: 'Start Timer',
                          onTap: _startTimer,
                        ),
                      ),
                    ],
                  )
                else
                  // Running: show Log Time, delete, stop, pause/resume
                  Row(
                    children: [
                      Expanded(
                        child: _OutlineActionButton(
                          label: 'Log Time',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddTimeEntryPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      _IconActionButton(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.warn,
                        onTap: _discardTimer,
                      ),
                      SizedBox(width: Dimensions.width10),
                      _IconActionButton(
                        icon: Icons.stop_rounded,
                        color: AppColors.warn,
                        onTap: _openAssociateProjectPage,
                      ),
                      SizedBox(width: Dimensions.width10),
                      _IconActionButton(
                        icon: _isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: context.colors.textPrimary,
                        onTap: _isPaused ? _resumeTimer : _pauseTimer,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height15),

          // Stat chips row
          Row(
            children: [
              Expanded(
                child: _StatCard(label: 'Unbilled Hours', value: '00:00'),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: _StatCard(label: 'Unbilled Expenses', value: '₹0.00'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------- Outline Action Button --------
class _OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          border: Border.all(color: context.colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// -------- Filled Action Button --------
class _FilledActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilledActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.info,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// -------- Icon Action Button --------
class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Icon(icon, color: color, size: Dimensions.iconSize20),
      ),
    );
  }
}

// -------- Stat Card --------
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height10 * 0.4),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 1.1,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
