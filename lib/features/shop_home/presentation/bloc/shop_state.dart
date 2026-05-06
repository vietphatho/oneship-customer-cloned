import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';

part 'shop_state.freezed.dart';

@freezed
abstract class ShopState with _$ShopState {
  const factory ShopState({
    @Default("") String userId,
    required Resource<ShopDailySummaryEntity> dailySummaryResource,
    required Resource<GetShopsEntity> shopsResource,
    ShopEntity? currentShop,
    @Default([]) List<ShopEntity> filteredShops,
  }) = _ShopState;
}
