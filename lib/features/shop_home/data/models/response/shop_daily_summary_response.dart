import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_daily_summary_response.freezed.dart';
part 'shop_daily_summary_response.g.dart';

@freezed
abstract class ShopDailySummaryResponse with _$ShopDailySummaryResponse {
  const factory ShopDailySummaryResponse({
    String? logo,
    String? shopName,
    String? status,
    int? totalOrdersPickedUpToday,
    int? totalCodAmountToday,
    int? totalDeliveryFeeToday,
  }) = _ShopDailySummaryResponse;

  factory ShopDailySummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ShopDailySummaryResponseFromJson(json);
}
