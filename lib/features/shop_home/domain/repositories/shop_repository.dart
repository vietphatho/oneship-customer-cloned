import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';

abstract class ShopRepository extends BaseRepository {
  Future<Resource<GetShopsEntity>> getShops(String userId);

  Future<Resource<ShopDailySummaryEntity>> fetchShopDailySummary(String shopId);
}
