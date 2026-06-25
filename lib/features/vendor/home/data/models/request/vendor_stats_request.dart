import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';

class VendorStatsRequest {
  const VendorStatsRequest({
    required this.shopId,
    required this.vendorId,
    required this.startDate,
    required this.endDate,
  });

  final String shopId;
  final String vendorId;
  final DateTime startDate;
  final DateTime endDate;

  String get startDateText =>
      DateFormat(Constants.requestDateFormat).format(startDate);

  String get endDateText =>
      DateFormat(Constants.requestDateFormat).format(endDate);

  String get cacheKey => '$shopId|$vendorId|$startDateText|$endDateText';
}
