import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_search_field.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/core/widgets/empty_state_widget.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:custom_books/features/documents/widgets/document_filter_sheet.dart';
import 'package:custom_books/features/documents/widgets/document_sort_sheet.dart';
import 'package:custom_books/features/documents/widgets/document_page_widgets.dart';
import 'package:custom_books/core/widgets/more_options_sheet.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:custom_books/core/enums/sort_direction.dart';

class AllFilesPage extends StatefulWidget {
  const AllFilesPage({super.key});

  @override
  State<AllFilesPage> createState() => _AllFilesPageState();
}

class _AllFilesPageState extends State<AllFilesPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _searchOpen = false;
  DocumentType? _typeFilter;
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
        folderName: 'Invoices',
        createdAt: DateTime(2026, 7, 3, 10, 0),
      ),
      DocumentModel(
        id: '2',
        fileName: 'Receipt_scan.jpg',
        fileType: DocumentType.image,
        sizeBytes: 1856432,
        uploadedDate: DateTime(2026, 7, 2),
        folderName: 'Receipts',
        createdAt: DateTime(2026, 7, 2, 9, 30),
      ),
      DocumentModel(
        id: '3',
        fileName: 'Expenses_Q2.xlsx',
        fileType: DocumentType.spreadsheet,
        sizeBytes: 53248,
        uploadedDate: DateTime(2026, 6, 30),
        folderName: 'Reports',
        createdAt: DateTime(2026, 6, 30, 14, 0),
      ),
      DocumentModel(
        id: '4',
        fileName: 'Contract_draft.docx',
        fileType: DocumentType.doc,
        sizeBytes: 128900,
        uploadedDate: DateTime(2026, 6, 28),
        folderName: 'Contracts',
        createdAt: DateTime(2026, 6, 28, 11, 15),
      ),
      DocumentModel(
        id: '5',
        fileName: 'Logo_final.png',
        fileType: DocumentType.image,
        sizeBytes: 987654,
        uploadedDate: DateTime(2026, 6, 25),
        folderName: 'Branding',
        createdAt: DateTime(2026, 6, 25, 16, 45),
      ),
      DocumentModel(
        id: '6',
        fileName: 'Notes.txt',
        fileType: DocumentType.other,
        sizeBytes: 2048,
        uploadedDate: DateTime(2026, 6, 20),
        folderName: 'Misc',
        createdAt: DateTime(2026, 6, 20, 8, 10),
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
      if (_typeFilter != null && doc.fileType != _typeFilter) return false;
      return query.isEmpty ||
          doc.fileName.toLowerCase().contains(query) ||
          doc.folderName.toLowerCase().contains(query);
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

  void _showMoreOptions() {
    MoreOptionsSheet.show(
      context,
      sectionLabel: 'FILE ACTIONS',
      items: [
        MoreOptionsItem(
          icon: Icons.upload_file_rounded,
          title: 'Upload File',
          subtitle: 'Add a new file to your documents',
          onTap: _upload,
        ),
        MoreOptionsItem(
          icon: Icons.refresh_rounded,
          title: 'Refresh',
          subtitle: 'Reload the latest files',
          onTap: () => setState(() {}),
        ),
      ],
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (_) => DocumentFilterSheet(
        selectedType: _typeFilter,
        onSelected: (type) => setState(() => _typeFilter = type),
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
      drawer: const DrawerView(currentRoute: 'all_files'),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: Dimensions.radius15 * 1.07,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _upload,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: const Icon(Icons.upload_file_rounded),
        ),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'All Files',
            subtitle:
                '${_documents.length} file${_documents.length == 1 ? '' : 's'}',
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
                hintText: 'Search by file or folder',
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
                      _typeFilter == null
                          ? 'All documents'
                          : _typeFilter!.label,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.8,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openFilterSheet,
                    child: _controlBadge(
                      _typeFilter == null
                          ? Icons.filter_list_rounded
                          : Icons.filter_alt_rounded,
                      active: _typeFilter != null,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10 / 2),
                  InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    onTap: _openSortSheet,
                    child: _controlBadge(Icons.swap_vert_rounded),
                  ),
                ],
              ),
            ),
            if (_typeFilter != null)
              Container(
                margin: EdgeInsets.fromLTRB(
                  Dimensions.width20,
                  0,
                  Dimensions.width20,
                  Dimensions.height10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height10 / 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_rounded,
                      size: Dimensions.iconSize16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      'Type: ${_typeFilter!.label}',
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.72,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => setState(() => _typeFilter = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: Dimensions.iconSize16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: visibleList.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.folder_copy_rounded,
                      title: 'No files found',
                      subtitle: 'Tap the upload button to add files.',
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
                        itemBuilder: (context, index) => DocumentTile(
                          doc: visibleList[index],
                          onTap: () => ToastificationHelper.showSuccess(
                            context,
                            visibleList[index].fileName,
                          ),
                        ),
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
}
