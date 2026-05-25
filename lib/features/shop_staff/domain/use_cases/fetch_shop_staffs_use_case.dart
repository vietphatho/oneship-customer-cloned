import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/constants/constants.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/shop_staff/domain/entities/shop_staff_list_entity.dart';
import 'package:oneship_shop/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@lazySingleton
class FetchShopStaffsUseCase {
  final ShopStaffRepository _repository;

  FetchShopStaffsUseCase(this._repository);

  Future<Resource<ShopStaffListEntity>> call({
    required String shopId,
    int page = Constants.defaultPage,
    int limit = Constants.defaultLimitPerPage,
    String? displayName,
    String? userEmail,
    String? userStatus,
  }) {
    return _repository.fetchShopStaffs(
      shopId: shopId,
      page: page,
      limit: limit,
      displayName: displayName,
      userEmail: userEmail,
      userStatus: userStatus,
    );
  }
}
