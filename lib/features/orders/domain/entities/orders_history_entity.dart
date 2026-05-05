import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';

part 'orders_history_entity.freezed.dart';

@freezed
abstract class OrdersHistoryEntity with _$OrdersHistoryEntity {
  const OrdersHistoryEntity._();

  const factory OrdersHistoryEntity({
    required List<OrderHistoryInfoEntity> orders,
    BaseMetaResponse? meta,
  }) = _OrdersHistoryEntity;

  factory OrdersHistoryEntity.from(OrdersListResponse dto) {
    return OrdersHistoryEntity(
      orders:
          dto.data?.map((order) => OrderHistoryInfoEntity.from(order)).toList() ??
              [],
      meta: dto.meta,
    );
  }
}

@freezed
abstract class OrderHistoryInfoEntity with _$OrderHistoryInfoEntity {
  const OrderHistoryInfoEntity._();

  const factory OrderHistoryInfoEntity({
    String? id,
    String? orderNumber,
    String? customerName,
    String? phone,
    String? fullAddress,
    String? address,
    String? status,
    int? codAmount,
    DateTime? createdAt,
    int? city,
    int? provinceCode,
    int? ward,
    int? wardCode,
  }) = _OrderHistoryInfoEntity;

  factory OrderHistoryInfoEntity.from(OrderInfo dto) {
    return OrderHistoryInfoEntity(
      id: dto.id,
      orderNumber: dto.orderNumber,
      customerName: dto.customerName,
      phone: dto.phone,
      fullAddress: dto.fullAddress,
      address: dto.address,
      status: dto.status,
      codAmount: dto.codAmount,
      createdAt: dto.createdAt,
      city: dto.city,
      provinceCode: dto.provinceCode,
      ward: dto.ward,
      wardCode: dto.wardCode,
    );
  }
}
