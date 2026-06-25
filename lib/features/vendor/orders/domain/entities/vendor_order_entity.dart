import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_meta_entity.dart';
import 'package:oneship_customer/features/vendor/orders/data/models/response/vendor_orders_response.dart';

part 'vendor_order_entity.freezed.dart';

@freezed
abstract class VendorOrdersEntity with _$VendorOrdersEntity {
  const factory VendorOrdersEntity({
    @Default([]) List<VendorOrderEntity> items,
    BaseMetaEntity? meta,
  }) = _VendorOrdersEntity;

  factory VendorOrdersEntity.fromDto(VendorOrdersResponse dto) {
    return VendorOrdersEntity(
      items: dto.items?.map(VendorOrderEntity.fromDto).toList() ?? [],
      meta: dto.meta == null ? null : BaseMetaEntity.from(dto.meta!),
    );
  }
}

@freezed
abstract class VendorOrderEntity with _$VendorOrderEntity {
  const factory VendorOrderEntity({
    String? id,
    String? trackingCode,
    String? customerName,
    String? phone,
    String? fullAddress,
    String? status,
    int? deliveryFee,
    int? returnFee,
    int? codAmount,
    int? collectAmount,
    DateTime? createdAt,
  }) = _VendorOrderEntity;

  factory VendorOrderEntity.fromDto(VendorOrderResponse dto) {
    return VendorOrderEntity(
      id: dto.id,
      trackingCode: dto.trackingCode,
      customerName: dto.customerName,
      phone: dto.phone,
      fullAddress: dto.fullAddress,
      status: dto.status,
      deliveryFee: dto.deliveryFee,
      returnFee: dto.returnFee,
      codAmount: dto.codAmount,
      collectAmount: dto.collectAmount,
      createdAt: dto.createdAt,
    );
  }
}
