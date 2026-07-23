import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/inventory_adjustments/model/inventory_adjustments_model.dart';
import 'package:custom_books/features/inventory_adjustments/model/line_item_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdjustmentDetailsPage extends StatefulWidget {
  final InventoryAdjustment adjustment;

  const AdjustmentDetailsPage({super.key, required this.adjustment});

  @override
  State<AdjustmentDetailsPage> createState() => _AdjustmentDetailsPageState();
}

class _AdjustmentDetailsPageState extends State<AdjustmentDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data - replace with real data
  final List<PlatformFile> _attachments = [
    PlatformFile(
      name: 'screenshot_2026_07_21.png',
      size: 2457600, // ~2.3 MB
      path: '/mock/path/screenshot.png',
    ),
  ];

  final List<LineItem> _adjustedItems = [
    LineItem(
      id: '1',
      itemId: 'item_1',
      itemName: 'Pencil',
      description: 'urj',
      stockOnHand: 100.0,
      newQuantityOnHand: 150.0,
      quantityAdjusted: 50.0,
      costPrice: 25.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAttachmentsDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height45 * 1.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Attachments',
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 0.95,
                          fontWeight: FontWeight.w800,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize24,
                        color: Appcolors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Appcolors.border),

              // Attachment preview
              if (_attachments.isNotEmpty)
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(
                      color: Appcolors.surfaceLight,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border: Border.all(color: Appcolors.border),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      child: Image.asset(
                        'assets/images/placeholder_attachment.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 300,
                          color: Appcolors.surfaceLight,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: Dimensions.iconSize24 * 2,
                                  color: Appcolors.textSecondary,
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  _attachments.first.name,
                                  style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.85,
                                    color: Appcolors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Action buttons
              Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(
                      icon: Icons.download_rounded,
                      onTap: () {
                        // TODO: Download attachment
                      },
                    ),
                    _actionButton(
                      icon: Icons.delete_outline_rounded,
                      onTap: () {
                        // TODO: Delete attachment
                      },
                    ),
                  ],
                ),
              ),

              // Add attachment FAB
              Padding(
                padding: EdgeInsets.only(
                  right: Dimensions.width20,
                  bottom: Dimensions.height20,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      // TODO: Add attachment
                    },
                    backgroundColor: Appcolors.primary,
                    child: const Icon(
                      Icons.attach_file_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: Appcolors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: Appcolors.border),
        ),
        child: Icon(
          icon,
          size: Dimensions.iconSize24,
          color: Appcolors.textPrimary,
        ),
      ),
    );
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    final adjustment = widget.adjustment;
    final isDraft = adjustment.status == AdjustmentStatus.draft;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Adjustment Details',
          style: TextStyle(
            fontSize: Dimensions.font26 * 0.7,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: Colors.black54,
              size: Dimensions.iconSize24 - 2,
            ),
            onPressed: () {
              // TODO: Navigate to edit page
            },
          ),
          IconButton(
            icon: Icon(
              Icons.save_alt_rounded,
              color: Colors.black54,
              size: Dimensions.iconSize24 - 2,
            ),
            onPressed: () {
              // TODO: Save/Export action
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.black54,
              size: Dimensions.iconSize24 - 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: 8,
            onSelected: (value) {
              if (value == 'convert') {
                // Convert to adjusted (completed)
                setState(() {
                  // In real app, update via repository/bloc
                  // For now, just rebuild to show the change
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Adjustment marked as completed'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Appcolors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                );
              } else if (value == 'print') {
                // TODO: Print functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Print functionality coming soon'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Appcolors.textSecondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                );
              } else if (value == 'delete') {
                // TODO: Delete adjustment
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    title: Text(
                      'Delete Adjustment',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this adjustment? This action cannot be undone.',
                      style: TextStyle(
                        color: Appcolors.textSecondary,
                        fontSize: Dimensions.font16 * 0.9,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Appcolors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Appcolors.warn,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              if (isDraft)
                PopupMenuItem(
                  value: 'convert',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: Dimensions.iconSize16 + 4,
                        color: Appcolors.primary,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Convert to Adjusted',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                          color: Appcolors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(
                      Icons.print_rounded,
                      size: Dimensions.iconSize16 + 4,
                      color: Appcolors.textSecondary,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Print',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: Appcolors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: Dimensions.iconSize16 + 4,
                      color: Appcolors.warn,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: Appcolors.warn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: Dimensions.width10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with date, reason, and status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: Appcolors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10 + 2,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: (isDraft ? Appcolors.warn : Appcolors.primary)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius30,
                          ),
                        ),
                        child: Text(
                          adjustment.status.label,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.62,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: isDraft ? Appcolors.warn : Appcolors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2.5),
                  Text(
                    _formatDate(adjustment.date),
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.95,
                      fontWeight: FontWeight.w800,
                      color: Appcolors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason',
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.7,
                                color: Appcolors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 / 2.5),
                            Text(
                              adjustment.reason,
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 0.95,
                                fontWeight: FontWeight.w800,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_attachments.isNotEmpty)
                        GestureDetector(
                          onTap: _showAttachmentsDialog,
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.width10 + 2),
                            decoration: BoxDecoration(
                              color: Appcolors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(
                                color: Appcolors.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Badge(
                              label: Text(
                                '${_attachments.length}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Appcolors.accent,
                              child: Icon(
                                Icons.attach_file_rounded,
                                color: Appcolors.primary,
                                size: Dimensions.iconSize24 - 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),

            // Tabs
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  border: Border.all(
                    color: Appcolors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Appcolors.primary,
                unselectedLabelColor: Appcolors.textSecondary,
                labelStyle: TextStyle(
                  fontSize: Dimensions.font16 * 0.72,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
                dividerColor: Colors.transparent,
                padding: EdgeInsets.all(Dimensions.width10 / 2),
                tabs: const [
                  Tab(text: 'DETAILS'),
                  Tab(text: 'COMMENTS & HISTORY'),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Details tab
                  _buildDetailsTab(),
                  // Comments & History tab
                  _buildCommentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    final adjustment = widget.adjustment;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      physics: const BouncingScrollPhysics(),
      children: [
        // Account & Details section
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Account:', 'Cost of Goods Sold'),
              SizedBox(height: Dimensions.height15),
              _detailRow('Reference#:', 'lssj'),
              SizedBox(height: Dimensions.height15),
              _detailRow('Adjusted By:', adjustment.createdBy),
              SizedBox(height: Dimensions.height15),
              _detailRow('Adjustment Type:', 'Quantity'),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height15),

        // Adjusted Items section
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adjusted Items',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w800,
                  color: Appcolors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              ..._adjustedItems.map(
                (item) => Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10),
                  padding: EdgeInsets.all(Dimensions.width15),
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    border: Border.all(
                      color: Appcolors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: Dimensions.height45,
                        height: Dimensions.height45,
                        decoration: BoxDecoration(
                          color: Appcolors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                        ),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          color: Appcolors.primary,
                          size: Dimensions.iconSize24 - 2,
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.itemName,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.9,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.textPrimary,
                              ),
                            ),
                            if (item.description != null)
                              Text(
                                item.description!,
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.72,
                                  color: Appcolors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width15,
                          vertical: Dimensions.height10 / 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15 / 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Appcolors.primary.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          item.quantityAdjusted.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.85,
                            fontWeight: FontWeight.w800,
                            color: Appcolors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height15),

        // More Information section
        Container(
          padding: EdgeInsets.all(Dimensions.width20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More Information',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w800,
                  color: Appcolors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.72,
                  color: Appcolors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 2),
              Text(
                'Jjj',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.88,
                  color: Appcolors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height30),
      ],
    );
  }

  Widget _buildCommentsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: Appcolors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: Dimensions.iconSize24 * 2,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'No comments or history yet',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.95,
                fontWeight: FontWeight.w700,
                color: Appcolors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Comments and activity history\nwill appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.8,
                color: Appcolors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.78,
            color: Appcolors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.88,
              fontWeight: FontWeight.w700,
              color: Appcolors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
