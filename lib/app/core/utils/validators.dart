class Validators {
  // Validate name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // Validate quantity
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Invalid quantity';
    }
    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }
    return null;
  }

  // Validate price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Invalid price';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  // Validate category
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  // Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  // Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  // Validate numeric input
  static String? validateNumeric(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'This field is required' : null;
    }
    final numRegExp = RegExp(r'^[0-9]+$');
    if (!numRegExp.hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  // Validate decimal input
  static String? validateDecimal(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'This field is required' : null;
    }
    final decimalRegExp = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!decimalRegExp.hasMatch(value)) {
      return 'Invalid decimal format';
    }
    return null;
  }
}
