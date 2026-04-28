import 'package:oneship_customer/core/base/base_import_components.dart';

class Utils {
  Utils._();

  static String formatWeightWithUnit(num? value) {
    if (value == null) return "--";
    return "${value.toStringAsFixed(2)} ${Constants.weightUnit}";
  }

  static String formatCurrencyWithUnit(num? value) {
    if (value == null) return "--";
    return "${value.toStringAsFixed(0)} ${Constants.currencyUnit}";
  }

  static String formatDimensionWithUnit({
    required num? length,
    required num? width,
    required num? height,
  }) {
    if (length == null || width == null || height == null) return "--";
    return "${length.toStringAsFixed(0)} "
        "x ${width.toStringAsFixed(0)} "
        "x ${height.toStringAsFixed(0)} "
        "(${Constants.pkgDimensionsUnit})";
  }

  static double? mToKm(double? value) {
    if (value == null) return null;
    return value / 1000;
  }

  static String formatCurrency(num? value) {
    if (value == null) return "--";
    String strValue = value.toStringAsFixed(0);
    // Remove any existing dots or commas
    String cleanValue = strValue.replaceAll(RegExp(r'[.,]'), '');
    // Reverse the string
    String reversed = cleanValue.split('').reversed.join('');
    // Add dots every 3 characters
    String formatted = '';
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted += '.';
      }
      formatted += reversed[i];
    }
    // Reverse back
    return formatted.split('').reversed.join('');
  }
}
