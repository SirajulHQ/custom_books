enum QuoteStatus { draft, sent, accepted, declined, expired, converted }

class QuoteLineItem {
  final String id;
  final String itemName;
  final String description;
  final double quantity;
  final double rate;
  final double discount;
  final bool discountIsPercent;
  final double taxRate;

  const QuoteLineItem({
    required this.id,
    required this.itemName,
    this.description = '',
    required this.quantity,
    required this.rate,
    this.discount = 0,
    this.discountIsPercent = true,
    this.taxRate = 0,
  });

  double get gross => quantity * rate;
  double get discountAmount =>
      discountIsPercent ? gross * discount / 100 : discount;
  double get net => (gross - discountAmount).clamp(0, double.infinity);
  double get taxAmount => net * taxRate / 100;
}

class QuoteModel {
  final String id;
  final String quoteNumber;
  final String customerName;
  final String referenceNumber;
  final DateTime quoteDate;
  final DateTime? expiryDate;
  final String salesperson;
  final String projectName;
  final String subject;
  final bool taxInclusive;
  final List<QuoteLineItem> lineItems;
  final String customerNotes;
  final String termsAndConditions;
  final List<String> attachments;
  final QuoteStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuoteModel({
    required this.id,
    required this.quoteNumber,
    required this.customerName,
    this.referenceNumber = '',
    required this.quoteDate,
    this.expiryDate,
    this.salesperson = '',
    this.projectName = '',
    this.subject = '',
    this.taxInclusive = false,
    this.lineItems = const [],
    this.customerNotes = '',
    this.termsAndConditions = '',
    this.attachments = const [],
    this.status = QuoteStatus.draft,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subTotal => lineItems.fold(0, (sum, item) => sum + item.net);
  double get taxAmount =>
      lineItems.fold(0, (sum, item) => sum + item.taxAmount);
  double get total => taxInclusive ? subTotal : subTotal + taxAmount;

  QuoteModel copyWith({QuoteStatus? status}) => QuoteModel(
    id: id,
    quoteNumber: quoteNumber,
    customerName: customerName,
    referenceNumber: referenceNumber,
    quoteDate: quoteDate,
    expiryDate: expiryDate,
    salesperson: salesperson,
    projectName: projectName,
    subject: subject,
    taxInclusive: taxInclusive,
    lineItems: lineItems,
    customerNotes: customerNotes,
    termsAndConditions: termsAndConditions,
    attachments: attachments,
    status: status ?? this.status,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );
}

extension QuoteStatusLabel on QuoteStatus {
  String get label => name.replaceFirst(name[0], name[0].toUpperCase());
}
