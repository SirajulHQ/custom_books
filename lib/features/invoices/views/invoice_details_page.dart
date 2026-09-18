import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/confirmation_dialog.dart';
import 'package:custom_books/features/invoices/models/invoice_model.dart';
import 'package:custom_books/features/invoices/views/new_invoice_page.dart';
import 'package:custom_books/features/invoices/widgets/invoice_details_tab_view.dart';
import 'package:custom_books/features/invoices/widgets/invoice_header_card.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/widgets/custom_back_appbar.dart';
import 'package:custom_books/core/widgets/skeletons/skeletons.dart';

class InvoiceDetailsPage extends StatefulWidget {
  final InvoiceModel invoice;

  const InvoiceDetailsPage({super.key, required this.invoice});

  @override
  State<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Simulates fetching details so the shimmer skeleton is shown briefly.
  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoice;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: CustomBackAppBar(
        title: 'Invoice Details',
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
                  builder: (_) =>
                      NewInvoicePage(existingInvoice: widget.invoice),
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
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await showConfirmationDialog(
                  context,
                  title: 'Delete Invoice',
                  message:
                      'Are you sure you want to delete this invoice? This action cannot be undone.',
                );
                if (confirmed && context.mounted) {
                  Navigator.pop(context);
                }
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
        child: _isLoading
            ? const DetailsPageSkeleton()
            : Column(
                children: [
                  // Header section
                  InvoiceHeaderCard(invoice: invoice),
                  SizedBox(height: Dimensions.height15),

                  // Tabs
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceLight,
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: context.colors.card,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius30,
                        ),
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
                  Expanded(
                    child: InvoiceDetailsTabView(
                      invoice: invoice,
                      tabController: _tabController,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
