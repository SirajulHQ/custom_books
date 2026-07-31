import 'package:flutter/material.dart';

enum DocumentType { pdf, image, spreadsheet, doc, other }

extension DocumentTypeLabel on DocumentType {
  String get label => switch (this) {
    DocumentType.pdf => 'PDF',
    DocumentType.image => 'Image',
    DocumentType.spreadsheet => 'Spreadsheet',
    DocumentType.doc => 'Document',
    DocumentType.other => 'Other',
  };

  IconData get iconData => switch (this) {
    DocumentType.pdf => Icons.picture_as_pdf_rounded,
    DocumentType.image => Icons.image_rounded,
    DocumentType.spreadsheet => Icons.table_chart_rounded,
    DocumentType.doc => Icons.description_rounded,
    DocumentType.other => Icons.insert_drive_file_rounded,
  };
}

enum DocumentSortField { uploadedTime, name, size }

extension DocumentSortFieldLabel on DocumentSortField {
  String get label => switch (this) {
    DocumentSortField.uploadedTime => 'Uploaded Time',
    DocumentSortField.name => 'Name',
    DocumentSortField.size => 'Size',
  };
}

enum SortDirection { ascending, descending }

class DocumentModel {
  final String id;
  final String fileName;
  final DocumentType fileType;
  final int sizeBytes;
  final DateTime uploadedDate;
  final String folderName;
  final DateTime createdAt;

  const DocumentModel({
    required this.id,
    required this.fileName,
    this.fileType = DocumentType.other,
    this.sizeBytes = 0,
    required this.uploadedDate,
    this.folderName = '',
    required this.createdAt,
  });

  DocumentModel copyWith({
    String? id,
    String? fileName,
    DocumentType? fileType,
    int? sizeBytes,
    DateTime? uploadedDate,
    String? folderName,
    DateTime? createdAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedDate: uploadedDate ?? this.uploadedDate,
      folderName: folderName ?? this.folderName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FolderModel {
  final String id;
  final String name;
  final int fileCount;
  final DateTime createdAt;

  const FolderModel({
    required this.id,
    required this.name,
    this.fileCount = 0,
    required this.createdAt,
  });

  FolderModel copyWith({
    String? id,
    String? name,
    int? fileCount,
    DateTime? createdAt,
  }) {
    return FolderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileCount: fileCount ?? this.fileCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Formats a byte count into a human-readable KB/MB string.
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(1)} MB';
}
