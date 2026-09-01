import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:custom_books/features/documents/views/document_details_page.dart';
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

  void _openSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.width20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 0.85,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    ...DocumentSortField.values.map((field) {
                      final selected = _sortField == field;
                      return InkWell(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        onTap: () {
                          setState(() => _sortField = field);
                          setSheet(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: Dimensions.height10 / 2,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width15,
                            vertical: Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : context.colors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius15,
                            ),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : context.colors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                size: Dimensions.iconSize16 + 2,
                                color: selected
                                    ? AppColors.primary
                                    : context.colors.textTertiary,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                field.label,
                                style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.8,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Expanded(
                          child: _directionButton(
                            'Ascending',
                            Icons.arrow_upward_rounded,
                            SortDirection.ascending,
                            setSheet,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: _directionButton(
                            'Descending',
                            Icons.arrow_downward_rounded,
                            SortDirection.descending,
                            setSheet,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _directionButton(
    String label,
    IconData icon,
    SortDirection direction,
    StateSetter setSheet,
  ) {
    final selected = _sortDirection == direction;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () {
        setState(() => _sortDirection = direction);
        setSheet(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.primary : context.colors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize16 + 2,
              color: selected ? AppColors.primary : context.colors.textTertiary,
            ),
            SizedBox(width: Dimensions.width10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ),
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
                onPressed: _openSortSheet,
              ),
              SizedBox(width: Dimensions.width20),
            ],
          ),
        ],
        body: Column(
          children: [
            if (_searchOpen)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  Dimensions.height10,
                  Dimensions.width20,
                  Dimensions.height15,
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                  decoration: InputDecoration(
                    hintText: 'Search by file name',
                    hintStyle: TextStyle(color: context.colors.textTertiary),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: context.colors.textTertiary,
                    ),
                    filled: true,
                    fillColor: context.colors.card,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
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
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
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
                  ? _emptyState()
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

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.height45 * 1.6,
              height: Dimensions.height45 * 1.6,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No documents found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the upload button to add documents.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.75,
                color: context.colors.textSecondary,
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
