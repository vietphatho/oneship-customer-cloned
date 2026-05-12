import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@lazySingleton
class FetchShopStaffDetailUseCase {
  final ShopStaffRepository _repository;

  FetchShopStaffDetailUseCase(this._repository);

  Future<Resource<ShopStaffDetailEntity>> call({
    required String shopId,
    required String staffId,
  }) {
    return _repository.fetchShopStaffDetail(
      shopId: shopId,
      staffId: staffId,
    );
  }
}
