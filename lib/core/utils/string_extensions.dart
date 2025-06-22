extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  bool get isBlank => trim().isEmpty;
  
  bool get isNotBlank => !isBlank;
  
  String take(int count) {
    if (count >= length) return this;
    return substring(0, count);
  }
  
  String takeLast(int count) {
    if (count >= length) return this;
    return substring(length - count);
  }
  
  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length);
    }
    return this;
  }
  
  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
  
  String orDefault(String defaultValue) => isNotBlank ? this : defaultValue;
  
  bool get isNumeric => double.tryParse(this) != null;
  
  int toInt({int radix = 10, int? defaultValue}) {
    try {
      return int.parse(this, radix: radix);
    } catch (e) {
      return defaultValue ?? 0;
    }
  }
  
  double toDouble({double? defaultValue}) {
    try {
      return double.parse(this);
    } catch (e) {
      return defaultValue ?? 0.0;
    }
  }
  
  bool toBool() {
    final lower = toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'yes' || lower == 'y';
  }
  
  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${take(maxLength)}...';
  }
  
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
}
