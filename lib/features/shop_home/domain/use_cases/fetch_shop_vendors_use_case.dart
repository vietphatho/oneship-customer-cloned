import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchShopVendorsUseCase {
  const FetchShopVendorsUseCase(this._repository);

  final ShopRepository _repository;

  Future<Resource<List<ShopVendorEntity>>> call({
    required String shopId,
    int limit = 100,
  }) {
    return _repository.fetchShopVendors(shopId: shopId, limit: limit);
  }
}
