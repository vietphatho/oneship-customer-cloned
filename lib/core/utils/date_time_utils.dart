import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static final minDate = DateTime(1950);

  static final maxDate = DateTime(2100);

  static String? formatDate(String value) {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy");
      final dateTime = inputFormat.parse(value);

      return dateTime.toIso8601String();
    } catch (e) {
      return null;
    }
  }

  static String? formatDateFromDT(DateTime? value) {
    try {
      if (value == null) return null;

      final inputFormat = DateFormat(Constants.defaultDateFormat);
      return inputFormat.format(value);
    } catch (e) {
      return null;
    }
  }

  static String? formatTimeFromDT(DateTime? value) {
    try {
      if (value == null) return null;

      final inputFormat = DateFormat(Constants.defaultTimeFormat);
      return inputFormat.format(value);
    } catch (e) {
      return null;
    }
  }

  static String? formatDateTime(
    DateTime? dateTime, {
    String format = Constants.defaultDateTimeFormat,
  }) {
    if (dateTime == null) return "--";
    final dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  static Duration durationFromHoursDouble(double? hours) {
    if (hours == null) return Duration.zero;
    return Duration(milliseconds: (hours * 3600 * 1000).round());
  }

  static DateTime? parseToDateTime(String formatTime) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(formatTime);
    } catch (_) {
      return null;
    }
  }

  static String formatterString(String? timeString) {
    try {
      if (timeString == null || timeString.isEmpty) return "";
      return DateFormat(
        Constants.defaultDateFormat,
      ).format(DateTime.parse(timeString));
    } catch (e) {
      return timeString ?? "";
    }
  }
}
