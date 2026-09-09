import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:custom_books/features/documents/views/document_details_page.dart';
import 'package:custom_books/features/documents/widgets/document_sort_sheet.dart';
import 'package:custom_books/features/documents/widgets/documents_inbox_more_options_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class DocumentsInboxPage extends StatefulWidget {
  const DocumentsInboxPage({super.key});

  @override
  State<DocumentsInboxPage> createState() => _DocumentsInboxPageState();
}

class _DocumentsInboxPageState extends State<DocumentsInboxPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _searchOpen = false;
  DocumentSortField _sortField = DocumentSortField.uploadedTime;
  SortDirection _sortDirection = SortDirection.descending;

  late List<DocumentModel> _documents;

  @override
  void initState() {
    super.initState();
    _documents = [
      DocumentModel(
        id: '1',
        fileName: 'Invoice_July.pdf',
        fileType: DocumentType.pdf,
        sizeBytes: 245678,
        uploadedDate: DateTime(2026, 7, 3),
        folderName: 'Inbox',
        createdAt: DateTime(2026, 7, 3, 10, 0),
      ),
      DocumentModel(
        id: '2',
        fileName: 'Receipt_scan.jpg',
        fileType: DocumentType.image,
        sizeBytes: 1856432,
        uploadedDate: DateTime(2026, 7, 2),
        folderName: 'Inbox',
        createdAt: DateTime(2026, 7, 2, 9, 30),
      ),
      DocumentModel(
        id: '3',
        fileName: 'Expenses_Q2.xlsx',
        fileType: DocumentType.spreadsheet,
        sizeBytes: 53248,
        uploadedDate: DateTime(2026, 6, 30),
        folderName: 'Inbox',
        createdAt: DateTime(2026, 6, 30, 14, 0),
      ),
      DocumentModel(
        id: '4',
        fileName: 'Contract_draft.docx',
        fileType: DocumentType.doc,
        sizeBytes: 128900,
        uploadedDate: DateTime(2026, 6, 28),
        folderName: 'Inbox',
        createdAt: DateTime(2026, 6, 28, 11, 15),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DocumentModel> get _visibleDocuments {
    final query = _searchController.text.trim().toLowerCase();
    final list = _documents.where((doc) {
      return query.isEmpty || doc.fileName.toLowerCase().contains(query);
    }).toList();

    list.sort((a, b) {
      int result;
      switch (_sortField) {
        case DocumentSortField.uploadedTime:
          result = a.createdAt.compareTo(b.createdAt);
        case DocumentSortField.name:
          result = a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase());
        case DocumentSortField.size:
          result = a.sizeBytes.compareTo(b.sizeBytes);
      }
      return _sortDirection == SortDirection.ascending ? result : -result;
    });

    return list;
  }

  void _upload() {
    ToastificationHelper.showSuccess(context, 'Upload coming soon');
  }

  void _openDocument(DocumentModel doc) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetailsPage(
          document: doc,
          onDelete: () {
            setState(() => _documents.removeWhere((d) => d.id == doc.id));
            ToastificationHelper.showSuccess(context, 'Document deleted');
          },
        ),
      ),
    );
  }

  void _showMoreOptions() {
    DocumentsInboxMoreOptionsSheet.show(
      context,
      onUpload: _upload,
      onRefresh: () => setState(() {}),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DocumentSortSheet(
        selectedField: _sortField,
        selectedDirection: _sortDirection,
        onApply: (field, direction) => setState(() {
          _sortField = field;
          _sortDirection = direction;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleDocuments;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'documents_inbox'),

      floatingActionButton: CustomAddButton(
        onPressed: _upload,
        icon: Icons.upload_file_rounded,
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Inbox',
            subtitle:
                '${_documents.length} document${_documents.length == 1 ? '' : 's'}',
            leadingType: AppBarLeadingType.menu,
            actions: [
              AppBarIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onPressed: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) _searchController.clear();
                }),
              ),
              SizedBox(width: Dimensions.width10),
              AppBarIconButton(
                icon: Icons.more_vert_rounded,
                color: AppColors.accent,
                onPressed: _showMoreOptions,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: Column(
          children: [
            if (_searchOpen)
              ListSearchField(
                controller: _searchController,
                hintText: 'Search by file name',
                onChanged: (_) => setState(() {}),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height10 / 2,
                Dimensions.width20,
                Dimensions.height15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recently received',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openSortSheet,
                    child: _controlBadge(Icons.swap_vert_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.inbox_rounded,
                      title: 'No documents found',
                      subtitle: 'Tap the upload button to add documents.',
                    )
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          Dimensions.width20,
                          0,
                          Dimensions.width20,
                          Dimensions.listBottomSpace,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: visibleList.length,
                        itemBuilder: (context, index) =>
                            _documentTile(visibleList[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlBadge(IconData icon, {bool active = false}) {
    return Container(
      width: Dimensions.height45 * 0.9,
      height: Dimensions.height45 * 0.9,
      decoration: BoxDecoration(
        color: (active ? AppColors.accent : AppColors.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(
        icon,
        size: Dimensions.iconSize24 - 4,
        color: active ? AppColors.accent : AppColors.primary,
      ),
    );
  }

  Widget _documentTile(DocumentModel doc) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => _openDocument(doc),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10),
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.height45 * 0.78,
              height: Dimensions.height45 * 0.78,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                doc.fileType.iconData,
                color: AppColors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.fileName,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Row(
                    children: [
                      Text(
                        doc.fileType.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Text(
                        formatBytes(doc.sizeBytes),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          formatDate(doc.uploadedDate),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
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
