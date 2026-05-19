import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@lazySingleton
class CreateShopStaffUseCase {
  const CreateShopStaffUseCase(this._repository);

  final ShopStaffRepository _repository;

  Future<Resource> call(CreateShopStaffRequest request) {
    return _repository.createShopStaff(request);
  }
}
