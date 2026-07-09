import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ProjectTimerCardWidget extends StatelessWidget {
  const ProjectTimerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Timer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.schedule_rounded,
                color: Appcolors.primaryLight,
                size: Dimensions.iconSize16,
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            '00:00:00',
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font26 * 1.3,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: OutlineChip(label: 'Log Time', color: Colors.white),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: FilledChip(
                  label: 'Start Timer',
                  color: Appcolors.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Row(
            children: [
              Expanded(
                child: StatChip(label: 'Unbilled Hours', value: '00:00'),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: StatChip(label: 'Unbilled Expenses', value: 'AED0.00'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------- Outline Chip Widget --------
class OutlineChip extends StatelessWidget {
  final String label;
  final Color color;

  const OutlineChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -------- Filled Chip Widget --------
class FilledChip extends StatelessWidget {
  final String label;
  final Color color;

  const FilledChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -------- Stat Chip Widget --------
class StatChip extends StatelessWidget {
  final String label;
  final String value;

  const StatChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: Dimensions.font16 * 0.65,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}