import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/features/credit_notes/models/credit_note_model.dart';
import 'package:custom_books/features/credit_notes/views/add_credit_note_page.dart';
import 'package:custom_books/features/credit_notes/widgets/credit_note_card.dart';
import 'package:custom_books/features/credit_notes/widgets/note_details_tab_view.dart';
import 'package:flutter/material.dart';

class CreditNoteDetailsPage extends StatefulWidget {
  final CreditNoteModel note;

  const CreditNoteDetailsPage({super.key, required this.note});

  @override
  State<CreditNoteDetailsPage> createState() => _CreditNoteDetailsPageState();
}

class _CreditNoteDetailsPageState extends State<CreditNoteDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final statusColor = note.status.color;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'Credit Note Details',
        backgroundColor: context.colors.card,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24 - 2,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCreditNotePage(existing: widget.note),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.colors.textSecondary,
              size: Dimensions.iconSize24 - 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            surfaceTintColor: context.colors.card,
            color: context.colors.card,
            elevation: 8,
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: context.colors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    title: Text(
                      'Delete Credit Note',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimensions.font20,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this credit note? This action cannot be undone.',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: Dimensions.font16 * 0.9,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: context.colors.textSecondary,
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
                            color: AppColors.warn,
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
              PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(
                      Icons.print_rounded,
                      size: Dimensions.iconSize16 + 4,
                      color: context.colors.textSecondary,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Print',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
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
                      color: AppColors.warn,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.85,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warn,
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
            // Header section
            CreditNoteCard(note: note, statusColor: statusColor),
            SizedBox(height: Dimensions.height15),

            // Tabs
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                color: context.colors.surfaceLight,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: Dimensions.radius15 * 0.53,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primary,
                unselectedLabelColor: context.colors.textSecondary,
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
            NoteDetailsTabView(tabController: _tabController, note: note),
          ],
        ),
      ),
    );
  }
}
