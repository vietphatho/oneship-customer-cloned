import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/shop_daily_summary_response.dart';

part 'shop_daily_summary_entity.freezed.dart';

@freezed
abstract class ShopDailySummaryEntity with _$ShopDailySummaryEntity {
  const factory ShopDailySummaryEntity({
    @Default("") String logo,
    @Default("") String shopName,
    String? status,
    @Default(0) int totalOrdersPickedUpToday,
    @Default(0) int totalCodAmountToday,
    @Default(0) int totalDeliveryFeeToday,
  }) = _ShopDailySummaryEntity;

  factory ShopDailySummaryEntity.from(ShopDailySummaryResponse dto) {
    return ShopDailySummaryEntity(
      logo: dto.logo ?? "",
      shopName: dto.shopName ?? "",
      status: dto.status,
      totalOrdersPickedUpToday: dto.totalOrdersPickedUpToday ?? 0,
      totalCodAmountToday: dto.totalCodAmountToday ?? 0,
      totalDeliveryFeeToday: dto.totalDeliveryFeeToday ?? 0,
    );
  }
}
