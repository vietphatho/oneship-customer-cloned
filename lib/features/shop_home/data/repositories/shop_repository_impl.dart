import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/data/data_sources/shop_api.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@LazySingleton(as: ShopRepository)
class ShopRepositoryImpl extends ShopRepository {
  final ShopApi _api;

  ShopRepositoryImpl(this._api);

  @override
  Future<Resource<GetShopsEntity>> getShops(String userId) async {
    final response = await request(() => _api.getShops(userId));
    return response.parse((dto) => GetShopsEntity.from(dto));
  }

  @override
  Future<Resource<ShopDailySummaryEntity>> fetchShopDailySummary(
    String shopId,
  ) async {
    final response = await request(() => _api.fetchShopDailySummary(shopId));
    return response.parse((dto) => ShopDailySummaryEntity.from(dto));
  }
}
