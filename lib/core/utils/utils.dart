import 'package:oneship_customer/core/base/base_import_components.dart';

class Utils {
  Utils._();

  static String formatWeightWithUnit(num? value) {
    if (value == null) return "--";
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return "${formatter.format(value)} ${Constants.weightUnit}";
  }

  static String formatCurrencyWithUnit(num? value) {
    if (value == null) return "--";
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: Constants.currencyUnit,
    );

    return formatter.format(value);
  }

  static String formatCompactCurrency(num? value) {
    if (value == null) return "--";

    if (value >= 1000000) {
      final formatted = (value / 1000000).toStringAsFixed(1);
      return '${_trimTrailingDecimalZero(formatted)}M ${Constants.currencyUnit}';
    }
    if (value >= 1000) {
      final formatted = (value / 1000).toStringAsFixed(1);
      return '${_trimTrailingDecimalZero(formatted)}K ${Constants.currencyUnit}';
    }

    return '${value.toStringAsFixed(0)}${Constants.currencyUnit}';
  }

  static String formatPercent(num? value) {
    if (value == null) return "--";
    final fractionDigits = value.truncateToDouble() == value ? 0 : 1;
    return '${value.toStringAsFixed(fractionDigits)}%';
  }

  static String formatCurrencyInput(num? value) {
    if (value == null) return "";
    return NumberFormat.decimalPattern('vi_VN').format(value);
  }

  static int parseCurrencyInput(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'\D'), '')) ?? 0;
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

  static String formatDistance(num? distanceInMeters) {
    if (distanceInMeters == null) return "--";

    if (distanceInMeters < 1000) {
      return "${distanceInMeters.round()} m";
    }

    final distanceInKilometers = distanceInMeters / 1000;
    return "${distanceInKilometers.toStringAsFixed(1)} km";
  }

  static String formatPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return "--";
    String formatted = phone.trim();
    if (formatted.startsWith('+84')) {
      return '0${formatted.substring(3)}';
    } else if (formatted.startsWith('84')) {
      return '0${formatted.substring(2)}';
    }
    return formatted;
  }

  static String _trimTrailingDecimalZero(String value) {
    if (!value.endsWith('.0')) return value;
    return value.substring(0, value.length - 2);
  }
}
