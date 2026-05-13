import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/add_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/data/models/request/create_shop_staff_request.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_list_entity.dart';

abstract class ShopStaffRepository extends BaseRepository {
  Future<Resource<ShopStaffListEntity>> fetchShopStaffs({
    required String shopId,
    int page = 1,
    int limit = 10,
    String? displayName,
    String? userEmail,
    String? userStatus,
  });

  Future<Resource> createShopStaff(CreateShopStaffRequest request);

  Future<Resource> addStaffToShop({
    required String shopId,
    required AddShopStaffRequest request,
  });

  Future<Resource<ShopStaffDetailEntity>> fetchShopStaffDetail({
    required String shopId,
    required String staffId,
  });

  Future<Resource> toggleDisableShopStaff({
    required String shopId,
    required String staffId,
  });
}
