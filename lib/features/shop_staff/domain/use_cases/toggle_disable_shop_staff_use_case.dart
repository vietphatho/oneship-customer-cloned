import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@lazySingleton
class ToggleDisableShopStaffUseCase {
  const ToggleDisableShopStaffUseCase(this._repository);

  final ShopStaffRepository _repository;

  Future<Resource> call({required String shopId, required String staffId}) {
    return _repository.toggleDisableShopStaff(
      shopId: shopId,
      staffId: staffId,
    );
  }
}
