class ValidationUtils {
  static String? validate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    } else if (value.contains(' ')) {
      return 'Spaces are not allowed in $fieldName';
    } 
    return null;
  }
}
