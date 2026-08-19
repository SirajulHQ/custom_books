import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/toastification_helper.dart';
import 'package:custom_books/core/widgets/custom_add_button.dart';
import 'package:custom_books/core/widgets/custom_sliver_appbar.dart';
import 'package:custom_books/features/documents/models/document_model.dart';
import 'package:custom_books/features/drawer/views/custom_drawer.dart';
import 'package:flutter/material.dart';

class FoldersPage extends StatefulWidget {
  const FoldersPage({super.key});

  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _searchOpen = false;

  late List<FolderModel> _folders;

  @override
  void initState() {
    super.initState();
    _folders = [
      FolderModel(
        id: '1',
        name: 'Invoices',
        fileCount: 12,
        createdAt: DateTime(2026, 7, 3),
      ),
      FolderModel(
        id: '2',
        name: 'Receipts',
        fileCount: 8,
        createdAt: DateTime(2026, 7, 2),
      ),
      FolderModel(
        id: '3',
        name: 'Contracts',
        fileCount: 5,
        createdAt: DateTime(2026, 6, 30),
      ),
      FolderModel(
        id: '4',
        name: 'Reports',
        fileCount: 3,
        createdAt: DateTime(2026, 6, 28),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FolderModel> get _visibleFolders {
    final query = _searchController.text.trim().toLowerCase();
    return _folders
        .where((f) => query.isEmpty || f.name.toLowerCase().contains(query))
        .toList();
  }

  void _openNewFolderSheet() {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: Dimensions.width20,
            right: Dimensions.width20,
            top: Dimensions.height20,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom +
                Dimensions.height20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Folder',
                style: TextStyle(
                  fontSize: Dimensions.font20 * 0.85,
                  fontWeight: FontWeight.w800,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(fontSize: Dimensions.font16 * 0.85),
                decoration: InputDecoration(
                  hintText: 'Folder name',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
                  prefixIcon: Icon(
                    Icons.folder_rounded,
                    color: context.colors.textTertiary,
                  ),
                  filled: true,
                  fillColor: context.colors.surfaceLight,
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
              SizedBox(height: Dimensions.height20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    final name = controller.text.trim();
                    if (name.isEmpty) {
                      ToastificationHelper.showError(
                        sheetContext,
                        'Please enter a folder name',
                      );
                      return;
                    }
                    setState(() {
                      _folders.insert(
                        0,
                        FolderModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          fileCount: 0,
                          createdAt: DateTime.now(),
                        ),
                      );
                    });
                    Navigator.pop(sheetContext);
                    ToastificationHelper.showSuccess(
                      context,
                      'Folder "$name" created',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.9,
                      fontWeight: FontWeight.w700,
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

  @override
  Widget build(BuildContext context) {
    final visibleList = _visibleFolders;

    return Scaffold(
      backgroundColor: context.colors.background,
      drawer: const DrawerView(currentRoute: 'folders'),

      floatingActionButton: CustomAddButton(
        onPressed: _openNewFolderSheet,
        icon: Icons.create_new_folder_rounded,
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) => [
          CustomSliverAppBar(
            title: 'Folders',
            subtitle:
                '${_folders.length} folder${_folders.length == 1 ? '' : 's'}',
            leadingType: AppBarLeadingType.menu,
            actions: [
              AppBarIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onPressed: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) _searchController.clear();
                }),
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
                    hintText: 'Search folders',
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
            Expanded(
              child: visibleList.isEmpty
                  ? _emptyState()
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        Dimensions.width20,
                        Dimensions.height15,
                        Dimensions.width20,
                        Dimensions.height30 * 2,
                      ),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Dimensions.width15,
                        mainAxisSpacing: Dimensions.height15,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: visibleList.length,
                      itemBuilder: (context, index) =>
                          _folderCard(visibleList[index]),
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
                Icons.folder_rounded,
                size: Dimensions.iconSize24 * 1.3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Text(
              'No folders found',
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              'Tap the + button to create a new folder.',
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

  Widget _folderCard(FolderModel folder) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: () => ToastificationHelper.showSuccess(context, folder.name),
      child: Container(
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.height45,
              height: Dimensions.height45,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Icon(
                Icons.folder_rounded,
                color: AppColors.primary,
                size: Dimensions.iconSize24,
              ),
            ),
            const Spacer(),
            Text(
              folder.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 3),
            Text(
              '${folder.fileCount} file${folder.fileCount == 1 ? '' : 's'}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
