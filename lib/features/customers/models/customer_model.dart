class CustomerModel {
  final String id;
  final String name;
  final String? email;
  final String? mobileNumber;
  final String? workPhone;
  final double receivables;
  final double unusedCredits;
  final bool isActive;

  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.mobileNumber,
    this.workPhone,
    required this.receivables,
    required this.unusedCredits,
    this.isActive = true,
  });

  // Get initials from name
  String get initials {
    final words = name.trim().split(' ');
    if (words.isEmpty) return 'UN';
    if (words.length == 1) {
      return words[0].substring(0, words[0].length > 2 ? 2 : 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
