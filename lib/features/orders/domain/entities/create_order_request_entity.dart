import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/routing_entity.dart';

part 'create_order_request_entity.freezed.dart';

@freezed
abstract class CreateOrderRequestEntity with _$CreateOrderRequestEntity {
  const CreateOrderRequestEntity._();

  factory CreateOrderRequestEntity.empty() => _CreateOrderRequestEntity(
    detail: DetailEntity(),
    router: RoutingEntity(),
  );

  const factory CreateOrderRequestEntity({
    String? externalOrderId,
    DeliveryServiceType? serviceCode,
    @Default([]) List<String> surchargeCodes,
    String? orderNumber,
    int? codAmount,
    String? status,
    String? fullAddress,
    String? fullAddressOld,
    Ward? ward,
    Province? province,
    @Default(false) bool isNewAddress,
    String? phone,
    String? customerName,
    String? email,
    String? orderItems,
    String? paymentStatus,
    String? paymentMethod,
    String? packageType,
    String? shopId,
    @Default(Payer.recipient) Payer payer,
    @Default(true) bool agreeTerms,
    DetailEntity? detail,
    @Default([]) List<SelectedProductEntity> selectedProducts,
    RoutingEntity? router,
  }) = _CreateOrderRequestEntity;

  CreateOrderRequest toDto() {
    return CreateOrderRequest(
      externalOrderId: externalOrderId,
      serviceCode: serviceCode?.requestValue,
      surchargeCodes: surchargeCodes,
      orderNumber: orderNumber,
      codAmount: codAmount,
      status: status,
      fullAddress: fullAddress,
      fullAddressOld: fullAddressOld,
      wardCode: ward?.code.toString(),
      wardName: ward?.name,
      provinceCode: province?.code.toString(),
      provinceName: province?.name,
      isNewAddress: isNewAddress,
      phone: phone,
      customerName: customerName,
      email: email,
      orderItems: orderItems,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      packageType: packageType,
      shopId: shopId,
      payer: payer.requestValue,
      agreeTerms: agreeTerms,
      detail: detail?.toDto(),
      selectedProducts: selectedProducts.map((e) => e.toDto()).toList(),
      router: CreateOrderRouter(
        id: router?.id,
        distance: router?.distance,
        // time: router?
        bbox: router?.fullRouteData?.bbox,
        orderCoordinates: router?.orderCoordinates,
      ),
    );
  }
}

@freezed
abstract class DetailEntity with _$DetailEntity {
  const DetailEntity._();

  const factory DetailEntity({
    DateTime? pickupDate,
    OrderPickUpSession? pickupSession,
    String? deliveryTimeSlot,
    double? weight,
    @Default(false) bool isHighValueGoods,
    @Default(false) bool isFragile,
    @Default(false) bool isOnePiece,
    @Default(false) bool isLiquid,
    @Default(false) bool hasBattery,
    int? length,
    int? width,
    int? height,
    String? orderSource,
    String? note,
  }) = _DetailEntity;

  Detail toDto() {
    return Detail(
      pickupDate: pickupDate,
      pickupTimeSlot: pickupSession?.requestValue,
      deliveryTimeSlot: deliveryTimeSlot,
      weight: weight,
      isHighValueGoods: isHighValueGoods,
      isFragile: isFragile,
      isOnePiece: isOnePiece,
      isLiquid: isLiquid,
      hasBattery: hasBattery,
      length: length ?? 0,
      width: width ?? 0,
      height: height ?? 0,
      orderSource: orderSource,
      note: note,
    );
  }
}

@freezed
abstract class SelectedProductEntity with _$SelectedProductEntity {
  const SelectedProductEntity._();

  const factory SelectedProductEntity({
    String? id,
    String? name,
    String? sku,
    @Default(0) int price,
    @Default(0) int qty,
  }) = _SelectedProductEntity;

  SelectedProduct toDto() {
    return SelectedProduct(
      id: id,
      name: name,
      sku: sku,
      price: price,
      qty: qty,
    );
  }
}
