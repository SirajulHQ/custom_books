import 'dart:async';

import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class AssociateProjectPage extends StatefulWidget {
  final int initialElapsedSeconds;

  const AssociateProjectPage({super.key, required this.initialElapsedSeconds});

  @override
  State<AssociateProjectPage> createState() => _AssociateProjectPageState();
}

class _AssociateProjectPageState extends State<AssociateProjectPage> {
  Timer? _timer;
  late int _seconds;
  final _projectController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedTask;
  bool _isBillable = false;
  bool _hasSearched = false;
  List<String> _searchResults = [];

  // Dummy project list for search
  final List<String> _projects = [
    'Website Redesign',
    'Mobile App Development',
    'Marketing Campaign',
    'Internal Tools',
  ];

  String get _formattedTime {
    final hours = (_seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialElapsedSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _projectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onProjectSearch(String query) {
    setState(() {
      _hasSearched = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _projects
            .where((p) => p.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Associate Project',
          style: TextStyle(
            fontSize: Dimensions.font16 * 1.1,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.close,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height20),

                  // Timer display
                  Center(
                    child: Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: Dimensions.font26 * 1.5,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height30),

                  // Project Name field
                  _buildLabel(context, 'Project Name', isRequired: true),
                  SizedBox(height: Dimensions.height10 * 0.6),
                  _buildProjectSearchField(context),
                  SizedBox(height: Dimensions.height20),

                  // Task field
                  _buildLabel(context, 'Task', isRequired: true),
                  SizedBox(height: Dimensions.height10 * 0.6),
                  _buildTaskDropdown(context),
                  SizedBox(height: Dimensions.height20),

                  // Billable checkbox
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isBillable,
                          onChanged: (val) =>
                              setState(() => _isBillable = val ?? false),
                          activeColor: Appcolors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Billable',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),

                  // Notes field
                  _buildLabel(context, 'Notes', isRequired: false),
                  SizedBox(height: Dimensions.height10 * 0.6),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                        color: context.colors.textTertiary,
                        fontSize: Dimensions.font16 * 0.9,
                      ),
                      contentPadding: EdgeInsets.all(Dimensions.width15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        borderSide: BorderSide(color: Appcolors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stop Timer button pinned at bottom
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height10,
              Dimensions.width20,
              Dimensions.height20,
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _stopTimer,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height15,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Appcolors.info,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Text(
                      'Stop Timer',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 1.05,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(
    BuildContext context,
    String text, {
    required bool isRequired,
  }) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w500,
          color: context.colors.textSecondary,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Appcolors.warn),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildProjectSearchField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _projectController,
          onChanged: _onProjectSearch,
          decoration: InputDecoration(
            hintText: 'Search project...',
            hintStyle: TextStyle(
              color: context.colors.textTertiary,
              fontSize: Dimensions.font16 * 0.9,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10 * 1.2,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                // Add new project action
              },
              child: Icon(
                Icons.add,
                color: context.colors.textSecondary,
                size: Dimensions.iconSize20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide: BorderSide(color: Appcolors.primary),
            ),
          ),
        ),
        if (_hasSearched && _searchResults.isEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: Dimensions.width15,
              top: Dimensions.height10 * 0.4,
            ),
            child: Text(
              'No result found',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: Appcolors.warn,
              ),
            ),
          ),
        if (_searchResults.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: Dimensions.height10 * 0.4),
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Column(
              children: _searchResults
                  .map(
                    (project) => ListTile(
                      dense: true,
                      title: Text(
                        project,
                        style: TextStyle(fontSize: Dimensions.font16 * 0.9),
                      ),
                      onTap: () {
                        _projectController.text = project;
                        setState(() {
                          _searchResults = [];
                          _hasSearched = false;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show task selection
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10 * 1.2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTask ?? 'Select Task',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                color: _selectedTask != null
                    ? context.colors.textPrimary
                    : context.colors.textTertiary,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize20,
            ),
          ],
        ),
      ),
    );
  }
}
