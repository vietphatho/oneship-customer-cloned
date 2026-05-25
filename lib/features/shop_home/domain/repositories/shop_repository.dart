import 'package:oneship_shop/core/base/base_repository.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_shop/features/shop_home/domain/entities/shop_daily_summary_entity.dart';

abstract class ShopRepository extends BaseRepository {
  Future<Resource<GetBriefShopsEntity>> getBriefShops(String userId);

  Future<Resource<ShopDailySummaryEntity>> fetchShopDailySummary(String shopId);

  Future<Resource<CreateShopEntity>> createShop(CreateShopParams params);

  Future<Resource<GetShopsEntity>> getShops({int? page, int? limit});

  Future<Resource<List<ShippingServiceConfigEntity>>> getShippingServiceConfigs({
    required String shopId,
  });
}
