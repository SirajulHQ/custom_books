class FormValidators {
  // ═══════════════════════════════════════════════════════════════════
  // NAME VALIDATION (for first_name and last_name)
  // ═══════════════════════════════════════════════════════════════════

  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'First name must be at least 2 characters';
    }

    if (trimmed.length > 150) {
      return 'First name must not exceed 150 characters';
    }

    // Only letters, spaces, hyphens, apostrophes, periods
    final nameRegex = RegExp(r"^[a-zA-Z\s\-'.]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'First name can only contain letters, spaces, hyphens (-), apostrophes (\'), and periods (.)';
    }

    return null;
  }

  static String? validateLastName(String? value, {bool isRequired = false}) {
    // Last name is optional in registration but follows same validation rules
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Last name is required' : null;
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Last name must be at least 2 characters';
    }

    if (trimmed.length > 150) {
      return 'Last name must not exceed 150 characters';
    }

    // Only letters, spaces, hyphens, apostrophes, periods
    final nameRegex = RegExp(r"^[a-zA-Z\s\-'.]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Last name can only contain letters, spaces, hyphens (-), apostrophes (\'), and periods (.)';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // EMAIL VALIDATION
  // ═══════════════════════════════════════════════════════════════════

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmed = value.trim().toLowerCase();

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // PHONE VALIDATION (INDIAN)
  // ═══════════════════════════════════════════════════════════════════

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final trimmed = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Indian phone format validation
    // Accepts: +91XXXXXXXXXX, 91XXXXXXXXXX, 0XXXXXXXXXX, XXXXXXXXXX (10 digits)
    // Valid starting digits: 6, 7, 8, 9
    final indianPhoneRegex = RegExp(r'^(\+91|91|0)?[6-9][0-9]{9}$');

    if (!indianPhoneRegex.hasMatch(trimmed)) {
      return 'Please enter a valid Indian phone number (e.g., 9XXXXXXXXX)';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // PASSWORD VALIDATION
  // ═══════════════════════════════════════════════════════════════════

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.contains(' ')) {
      return 'Password cannot contain spaces';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for common passwords, all numeric, etc.
    if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Password cannot be entirely numeric';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // ADDRESS VALIDATION
  // ═══════════════════════════════════════════════════════════════════

  /// Full Name validation (for address)
  static String? validateAddressFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }

    if (trimmed.length > 150) {
      return 'Full name must not exceed 150 characters';
    }

    // Person name validation - letters, spaces, hyphens, apostrophes, periods
    final nameRegex = RegExp(r"^[a-zA-Z\s\-'.]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Full name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }

    return null;
  }

  /// Phone Number validation (for address)
  static String? validateAddressPhone(String? value) {
    return validatePhone(value);
  }

  /// Address validation
  /// Required, 5-500 characters
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 5) {
      return 'Address must be at least 5 characters';
    }

    if (trimmed.length > 500) {
      return 'Address must not exceed 500 characters';
    }

    return null;
  }

  /// City validation
  /// Required, 2-120 characters
  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'City must be at least 2 characters';
    }

    if (trimmed.length > 120) {
      return 'City must not exceed 120 characters';
    }

    return null;
  }

  /// State validation
  /// Optional, Maximum 120 characters
  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final trimmed = value.trim();
    if (trimmed.length > 120) {
      return 'State must not exceed 120 characters';
    }

    return null;
  }

  /// PIN Code validation (Indian postal code)
  /// Required, 6 digits
  static String? validatePinCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PIN code is required';
    }

    final trimmed = value.trim();
    final pinCodeRegex = RegExp(r'^[1-9][0-9]{5}$');

    if (!pinCodeRegex.hasMatch(trimmed)) {
      return 'Please enter a valid 6-digit PIN code';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════

  /// Normalize email (lowercase)
  static String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Normalize phone to E.164 format (+91XXXXXXXXXX)
  static String normalizePhone(String phone) {
    String cleaned = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Convert to E.164 format (+91XXXXXXXXXX)
    if (cleaned.startsWith('0091')) {
      return '+${cleaned.substring(2)}';
    } else if (cleaned.startsWith('91') && cleaned.length == 12) {
      return '+$cleaned';
    } else if (cleaned.startsWith('0') && cleaned.length == 11) {
      return '+91${cleaned.substring(1)}';
    } else if (cleaned.length == 10 && RegExp(r'^[6-9]').hasMatch(cleaned)) {
      return '+91$cleaned';
    } else if (cleaned.startsWith('+91')) {
      return cleaned;
    }

    return cleaned;
  }

  /// Get allowed address types
  static List<String> getAllowedAddressTypes() {
    return ['home', 'flat', 'office', 'apartment'];
  }

  /// Normalize address type (backend accepts lowercase)
  static String normalizeAddressType(String type) {
    final normalized = type.toLowerCase();

    // Handle aliases
    if (normalized == 'work') return 'office';
    if (normalized == 'other') return 'apartment';

    return normalized;
  }

  /// Validate address type
  static String? validateAddressType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address type is required';
    }

    final normalized = normalizeAddressType(value);
    final allowedTypes = getAllowedAddressTypes();

    if (!allowedTypes.contains(normalized)) {
      return 'Invalid address type. Allowed: home, flat, office, apartment';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  // BUSINESS/ITEM SPECIFIC VALIDATIONS
  // ═══════════════════════════════════════════════════════════════════

  /// Item name validation
  static String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Item name must be at least 2 characters';
    }

    if (trimmed.length > 200) {
      return 'Item name must not exceed 200 characters';
    }

    return null;
  }

  /// SKU validation
  static String? validateSKU(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'SKU is required' : null;
    }

    final trimmed = value.trim();
    if (trimmed.length > 50) {
      return 'SKU must not exceed 50 characters';
    }

    // SKU typically contains alphanumeric characters and hyphens
    final skuRegex = RegExp(r'^[a-zA-Z0-9\-_]+$');
    if (!skuRegex.hasMatch(trimmed)) {
      return 'SKU can only contain letters, numbers, hyphens, and underscores';
    }

    return null;
  }

  /// Price validation
  static String? validatePrice(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Price is required' : null;
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    if (price > 9999999.99) {
      return 'Price is too large';
    }

    return null;
  }

  /// Quantity validation
  static String? validateQuantity(String? value, {bool allowNegative = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }

    final quantity = double.tryParse(value.trim());
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }

    if (!allowNegative && quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }

  /// GST Number validation (Indian GST)
  static String? validateGSTNumber(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'GST number is required' : null;
    }

    final trimmed = value.trim().toUpperCase();

    // Indian GST format: 2 digits (state code) + 10 digits (PAN) + 1 digit (entity number) + 1 letter (Z) + 1 alphanumeric (checksum)
    // Example: 22AAAAA0000A1Z5
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    if (!gstRegex.hasMatch(trimmed)) {
      return 'Please enter a valid GST number (e.g., 22AAAAA0000A1Z5)';
    }

    return null;
  }

  /// PAN Number validation (Indian PAN)
  static String? validatePANNumber(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'PAN number is required' : null;
    }

    final trimmed = value.trim().toUpperCase();

    // Indian PAN format: 5 letters + 4 digits + 1 letter
    // Example: ABCDE1234F
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegex.hasMatch(trimmed)) {
      return 'Please enter a valid PAN number (e.g., ABCDE1234F)';
    }

    return null;
  }
}
