import 'package:oneship_customer/features/shop_staff/data/models/response/shop_staff_list_response.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';

class ShopStaffMetaEntity {
  final int total;
  final int totalPages;
  final bool hasNext;

  ShopStaffMetaEntity({
    required this.total,
    required this.totalPages,
    required this.hasNext,
  });
}

class ShopStaffListEntity {
  final List<ShopStaffEntity> items;
  final ShopStaffMetaEntity? meta;

  ShopStaffListEntity({required this.items, this.meta});

  factory ShopStaffListEntity.fromResponse(ShopStaffListResponse response) {
    return ShopStaffListEntity(
      items:
          response.items
              ?.map((item) => ShopStaffEntity.fromResponse(item))
              .toList() ??
          [],
      meta:
          response.meta != null
              ? ShopStaffMetaEntity(
                total: response.meta?.total ?? 0,
                totalPages: response.meta?.totalPages ?? 0,
                hasNext: response.meta?.hasNext ?? false,
              )
              : null,
    );
  }

  bool get hasMoreData => meta?.hasNext == true;
}
