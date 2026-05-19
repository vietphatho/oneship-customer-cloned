import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_detail_entity.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';

class ShopStaffState {
  const ShopStaffState({
    required this.staffsResource,
    required this.createStaffResource,
    required this.toggleDisableResource,
    required this.staffDetailResource,
    required this.addStaffToShopResource,
    this.currentShop,
    this.staffs = const [],
    this.total = 0,
    this.hasMoreData = false,
  });

  final Resource<List<ShopStaffEntity>> staffsResource;
  final Resource createStaffResource;
  final Resource toggleDisableResource;
  final Resource<ShopStaffDetailEntity> staffDetailResource;
  final Resource addStaffToShopResource;
  final BriefShopEntity? currentShop;
  final List<ShopStaffEntity> staffs;
  final int total;
  final bool hasMoreData;

  ShopStaffState copyWith({
    Resource<List<ShopStaffEntity>>? staffsResource,
    Resource? createStaffResource,
    Resource? toggleDisableResource,
    Resource<ShopStaffDetailEntity>? staffDetailResource,
    Resource? addStaffToShopResource,
    BriefShopEntity? currentShop,
    List<ShopStaffEntity>? staffs,
    int? total,
    bool? hasMoreData,
  }) {
    return ShopStaffState(
      staffsResource: staffsResource ?? this.staffsResource,
      createStaffResource: createStaffResource ?? this.createStaffResource,
      toggleDisableResource:
          toggleDisableResource ?? this.toggleDisableResource,
      staffDetailResource: staffDetailResource ?? this.staffDetailResource,
      addStaffToShopResource:
          addStaffToShopResource ?? this.addStaffToShopResource,
      currentShop: currentShop ?? this.currentShop,
      staffs: staffs ?? this.staffs,
      total: total ?? this.total,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
