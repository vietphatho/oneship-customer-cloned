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

}
