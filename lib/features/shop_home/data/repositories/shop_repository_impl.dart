import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/data/data_sources/promotions_and_news_api.dart';
import 'package:oneship_customer/features/shop_home/data/data_sources/shop_api.dart';
import 'package:oneship_customer/features/shop_home/data/models/request/create_shop_request.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/order_option_response.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/visible_surcharges_response.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_daily_summary_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@LazySingleton(as: ShopRepository)
class ShopRepositoryImpl extends ShopRepository {
  final ShopApi _api;
  final PromotionsAndNewsApi _promotionsAndNewsApi;

  ShopRepositoryImpl(this._api, this._promotionsAndNewsApi);

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

  @override
  Future<Resource<List<ShopVendorEntity>>> fetchShopVendors({
    required String shopId,
    required int limit,
  }) async {
    final response = await request(
      () => _api.fetchShopVendors(shopId: shopId, limit: limit),
    );
    return response.parse(
      (dto) => dto.items.map(ShopVendorEntity.from).toList(),
    );
  }

  @override
  Future<Resource<List<SurchargeGroupEntity>>> fetchVisibleSurcharges({
    required String shopId,
  }) async {
    final response = await request<VisibleSurchargesResponse, dynamic>(
      () => _api.fetchVisibleSurcharges(shopId: shopId),
    );

    return response.parse<List<SurchargeGroupEntity>>((dto) {
      return dto.data.map(SurchargeGroupEntity.from).toList();
    });
  }

  @override
  Future<Resource<List<OrderOptionEntity>>> fetchCommodityTypes({
    required String shopId,
  }) async {
    final response = await request<List<CommodityResponse>, dynamic>(
      () => _api.fetchCommodityTypes(shopId: shopId),
    );
    return response.parse<List<OrderOptionEntity>>(
      (dto) => dto.map(OrderOptionEntity.fromCommodity).toList(),
    );
  }

  @override
  Future<Resource<List<OrderOptionEntity>>> fetchHandlingTypes({
    required String shopId,
  }) async {
    final response = await request<List<HandlingResponse>, dynamic>(
      () => _api.fetchHandlingTypes(shopId: shopId),
    );
    return response.parse<List<OrderOptionEntity>>(
      (dto) => dto.map(OrderOptionEntity.fromHandling).toList(),
    );
  }

  @override
  Future<Resource<PromotionsPageEntity>> fetchMobilePosts({
    required MobilePostCategory category,
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _promotionsAndNewsApi.fetchByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );
      final totalPages = int.tryParse(
        response.response.headers.value('x-wp-totalpages') ?? '',
      );
      final items = response.data.map(PromotionProgramEntity.from).toList();

      return Resource.success(
        PromotionsPageEntity(
          items: items,
          page: page,
          hasMore: totalPages != null
              ? page < totalPages
              : items.length >= perPage,
        ),
      );
    } on DioException catch (e) {
      return Resource.error(
        'error_code.server_error',
        e.response?.statusCode ?? 0,
        err: e,
      );
    } catch (e) {
      return Resource.error('error_code.server_error', 0, err: e);
    }
  }
}
