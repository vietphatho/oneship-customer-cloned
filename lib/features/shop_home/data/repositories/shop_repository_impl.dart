import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/data/data_sources/shop_api.dart';
import 'package:oneship_customer/features/shop_home/data/models/request/create_shop_request.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@LazySingleton(as: ShopRepository)
class ShopRepositoryImpl extends ShopRepository {
  final ShopApi _api;

  ShopRepositoryImpl(this._api);

  @override
  Future<Resource<GetBriefShopsEntity>> getBriefShops({
    required String userId,
    int? page,
    int? limit,
  }) async {
    final response = await request(
      () => _api.getBriefShops(userId: userId, page: page, limit: limit),
    );
    return response.parse((dto) => GetBriefShopsEntity.from(dto));
  }

  @override
  Future<Resource<ShopDailySummaryEntity>> fetchShopDailySummary(
    String shopId,
  ) async {
    final response = await request(() => _api.fetchShopDailySummary(shopId));
    return response.parse((dto) => ShopDailySummaryEntity.from(dto));
  }

  @override
  Future<Resource<CreateShopEntity>> createShop(CreateShopParams params) async {
    final response = await request(
      () => _api.createShop(CreateShopRequest.fromParams(params)),
    );
    return response.parse<CreateShopEntity>(
      (dto) => CreateShopEntity.fromDto(dto),
    );
  }

  @override
  Future<Resource<GetShopsEntity>> getShops({int? page, int? limit}) async {
    final response = await request(
      () => _api.getShops(
        page: page ?? 1,
        limit: limit ?? Constants.defaultLimitPerPage,
      ),
    );
    return response.parse<GetShopsEntity>((dto) => GetShopsEntity.from(dto));
  }

  @override
  Future<Resource<List<ShippingServiceConfigEntity>>>
  getShippingServiceConfigs({required String shopId}) async {
    final response = await request(
      () => _api.getShippingServiceConfigs(shopId: shopId),
    );
    return response.parse(
      (dto) =>
          dto.data?.map((e) => ShippingServiceConfigEntity.from(e)).toList() ??
          [],
    );
  }

  @override
  Future<Resource<ShopVendorEntity>> fetchShopVendor({
    required String shopId,
    required String vendorId,
  }) async {
    final response = await request(
      () => _api.fetchShopVendor(shopId: shopId, vendorId: vendorId),
    );
    return response.parse((dto) => ShopVendorEntity.from(dto));
  }
}
