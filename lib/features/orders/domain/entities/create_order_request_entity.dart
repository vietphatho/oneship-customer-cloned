import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
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

  factory CreateOrderRequestEntity.fromResponseModel(OrderDetailEntity model) {
    return CreateOrderRequestEntity(
      externalOrderId: model.externalOrderId,

      serviceCode: DeliveryServiceType.values.firstWhere(
        (e) => e.requestValue == model.serviceCode,
        orElse: () => DeliveryServiceType.standard,
      ),

      orderNumber: model.orderNumber,

      codAmount: model.codAmount,

      status: model.status,

      fullAddress: model.fullAddress,
      fullAddressOld: model.fullAddressOld,

      ward:
          model.wardCode != null
              ? Ward(
                code: model.wardCode!,
                name: model.wardName ?? "",
                provinceCode: model.provinceCode!,
              )
              : null,

      province:
          model.provinceCode != null
              ? Province(
                code: model.provinceCode!,
                name: model.provinceName ?? "",
              )
              : null,

      isNewAddress: false,

      phone: model.phone,
      customerName: model.customerName,
      email: model.email,

      paymentStatus: model.paymentStatus,
      paymentMethod: model.paymentMethod,

      packageType: model.packageType,

      shopId: model.shopId,

      payer: Payer.values.firstWhere(
        (e) => e.requestValue == model.payer,
        orElse: () => Payer.recipient,
      ),

      agreeTerms: true,

      detail: DetailEntity(
        pickupDate: model.pickupDate,
        pickupSession:
            model.pickupTimeSlot != null
                ? OrderPickUpSession.values.firstWhere(
                  (e) => e.requestValue == model.pickupTimeSlot,
                  orElse: () => OrderPickUpSession.morning,
                )
                : null,
        deliveryTimeSlot: model.deliveryTimeSlot,
        weight: model.weight,
        length: model.length,
        width: model.width,
        height: model.height,
        isFragile: model.isFragile,
        isLiquid: model.isLiquid,
        hasBattery: model.hasBattery,
        note: model.note,
      ),

      selectedProducts:
          model.items
              .map(
                (e) => SelectedProductEntity(
                  id: e.id ?? "",
                  name: e.productName ?? "",
                  sku: e.productSku ?? "",
                  price: e.unitPrice,
                  quantity: e.quantity,
                ),
              )
              .toList(),

      router: const RoutingEntity(),
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
      // deliveryTimeSlot: deliveryTimeSlot,
      weight: weight,
      // isHighValueGoods: isHighValueGoods,
      // isFragile: isFragile,
      // isOnePiece: isOnePiece,
      // isLiquid: isLiquid,
      // hasBattery: hasBattery,
      length: length ?? 0,
      width: width ?? 0,
      height: height ?? 0,
      // orderSource: orderSource,
      note: note,
    );
  }
}
