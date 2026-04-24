import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';

part 'shop_state.freezed.dart';

@freezed
abstract class ShopState with _$ShopState {
  const ShopState._();

  const factory ShopState({
    @Default('') String userId,
    required Resource<ShopDailySummaryEntity> dailySummaryResource,
    required Resource<GetShopsEntity> shopsResource,
    required Resource<CreateShopEntity?> createShopResource,
    ShopEntity? currentShop,
  }) = _ShopState;

  List<ShopEntity> get shops => shopsResource.data?.data ?? const [];

  bool get isLoadingShops => shopsResource.state == Result.loading;

  bool get hasShopLoadError => shopsResource.state == Result.error;

  bool get isCreateShopLoading => createShopResource.state == Result.loading;

  bool get hasCreateShopSuccess =>
      createShopResource.state == Result.success &&
      createShopResource.data != null;
}
