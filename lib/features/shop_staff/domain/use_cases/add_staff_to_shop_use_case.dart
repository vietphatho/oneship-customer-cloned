import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/add_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@lazySingleton
class AddStaffToShopUseCase {
  const AddStaffToShopUseCase(this._repository);

  final ShopStaffRepository _repository;

  Future<Resource> call({
    required String shopId,
    required String userId,
    required Map<String, Map<String, bool>> permissions,
  }) {
    return _repository.addStaffToShop(
      shopId: shopId,
      request: AddShopStaffRequest(
        userId: userId,
        permissions: permissions,
      ),
    );
  }
}
