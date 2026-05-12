import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/data/data_sources/shop_staff_api.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/add_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_list_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/repositories/shop_staff_repository.dart';

@LazySingleton(as: ShopStaffRepository)
class ShopStaffRepositoryImpl extends ShopStaffRepository {
  final ShopStaffApi _shopStaffApi;

  ShopStaffRepositoryImpl(this._shopStaffApi);

  @override
  Future<Resource<ShopStaffListEntity>> fetchShopStaffs({
    required String shopId,
    int page = 1,
    int limit = 10,
    String? displayName,
    String? userEmail,
    String? userStatus,
  }) async {
    final response = await request(
      () => _shopStaffApi.fetchShopStaffs(
        shopId: shopId,
        queryShopId: shopId,
        page: page,
        limit: limit,
        displayName: displayName,
        userEmail: userEmail,
        userStatus: userStatus,
      ),
    );

    return response.parse((data) => ShopStaffListEntity.fromResponse(data));
  }

  @override
  Future<Resource> createShopStaff(CreateShopStaffRequest request) {
    return this.request(() => _shopStaffApi.createShopStaff(request));
  }

  @override
  Future<Resource> addStaffToShop({
    required String shopId,
    required AddShopStaffRequest request,
  }) {
    return this.request(
      () => _shopStaffApi.addStaffToShop(shopId: shopId, body: request),
    );
  }

  @override
  Future<Resource<ShopStaffDetailEntity>> fetchShopStaffDetail({
    required String shopId,
    required String staffId,
  }) async {
    final response = await request(
      () => _shopStaffApi.fetchShopStaffDetail(
        shopId: shopId,
        staffId: staffId,
      ),
    );

    return response.parse((data) => ShopStaffDetailEntity.fromResponse(data));
  }

  @override
  Future<Resource> toggleDisableShopStaff({
    required String shopId,
    required String staffId,
  }) {
    return request(
      () => _shopStaffApi.toggleDisableShopStaff(
        shopId: shopId,
        staffId: staffId,
      ),
    );
  }
}
