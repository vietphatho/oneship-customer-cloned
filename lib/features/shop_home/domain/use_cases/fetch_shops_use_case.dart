import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchShopsUseCase {
  final ShopRepository _repository;

  FetchShopsUseCase(this._repository);

  Future<Resource<GetBriefShopsEntity>> getBriefShops({
    required String userId,
    int? page,
    int? limit,
  }) {
    return _repository.getBriefShops(userId: userId, page: page, limit: limit);
  }

  Future<Resource<GetShopsEntity>> getShops({int? page, int? limit}) {
    return _repository.getShops(page: page, limit: limit);
  }

  Future<Resource<ShopVendorEntity>> fetchShopVendor({
    required String shopId,
    required String vendorId,
  }) {
    return _repository.fetchShopVendor(shopId: shopId, vendorId: vendorId);
  }
}
