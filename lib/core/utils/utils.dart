import 'package:oneship_customer/core/base/base_import_components.dart';

class Utils {
  Utils._();

  static String formatWeightWithUnit(num? value) {
    if (value == null) return "--";
    return "${value.toStringAsFixed(2)} ${Constants.weightUnit}";
  }

  static String formatCurrencyWithUnit(num? value) {
    if (value == null) return "--";
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: Constants.currencyUnit,
    );

    return formatter.format(value);
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
}
