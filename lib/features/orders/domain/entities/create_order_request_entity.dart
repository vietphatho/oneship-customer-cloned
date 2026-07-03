import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/routing_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';

part 'create_order_request_entity.freezed.dart';

@freezed
abstract class CreateOrderRequestEntity with _$CreateOrderRequestEntity {
  const CreateOrderRequestEntity._();

  factory CreateOrderRequestEntity.empty() => _CreateOrderRequestEntity(
    detail: DetailEntity(),
    router: RoutingEntity(),
  );

  const factory CreateOrderRequestEntity({
    String? externalId,
    ExternalType? externalType,
    ShippingServiceConfigEntity? serviceConfig,
    @Default([]) List<String> surchargeCodes,
    @Default({}) Map<String, int> surchargeValues,
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
    PackageSize? packageSize,
    String? shopId,
    @Default(Payer.recipient) Payer payer,
    @Default(true) bool agreeTerms,
    DetailEntity? detail,
    @Default([]) List<SelectedProductEntity> selectedProducts,
    RoutingEntity? router,
    HospitalMetadataEntity? hospitalMetadata,
  }) = _CreateOrderRequestEntity;

  CreateOrderRequest toDto() {
    final normalizedExternalId = externalId?.trim();
    return CreateOrderRequest(
      externalId: normalizedExternalId?.isNotEmpty == true
          ? normalizedExternalId
          : null,
      externalType: externalType,
      serviceCode: serviceConfig?.serviceCode,
      surchargeCodes: surchargeCodes,
      surchargeValues: surchargeValues.isEmpty ? null : surchargeValues,
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
      packageSize: packageSize?.requestValue,
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
      hospitalMetadata: hospitalMetadata?.toDto(),
    );
  }

  factory CreateOrderRequestEntity.fromResponseModel(
    OrderDetailEntity model, {
    List<ShippingServiceConfigEntity> shippingServices = const [],
  }) {
    final serviceConfig =
        shippingServices.findByServiceCode(model.serviceCode) ??
        (model.serviceCode != null
            ? ShippingServiceConfigEntity.fromValue(model.serviceCode!)
            : null);

    return CreateOrderRequestEntity(
      externalId: model.externalId,
      externalType: null,

      serviceConfig: serviceConfig,

      surchargeCodes: model.orderFees.surchargeCodes,
      surchargeValues: model.orderFees.surchargeValues,

      orderNumber: model.orderNumber,

      codAmount: model.codAmount,

      status: model.status,

      fullAddress: model.fullAddress,
      fullAddressOld: model.fullAddressOld,

      ward: model.wardCode != null
          ? Ward(
              code: model.wardCode!,
              name: model.wardName ?? "",
              provinceCode: model.provinceCode!,
            )
          : null,

      province: model.provinceCode != null
          ? Province(code: model.provinceCode!, name: model.provinceName ?? "")
          : null,

      isNewAddress: false,

      phone: model.phone,
      customerName: model.customerName,
      email: model.email,

      paymentStatus: model.paymentStatus,
      paymentMethod: model.paymentMethod,

      packageSize: model.packageSize,

      shopId: model.shopId,

      payer: Payer.values.firstWhere(
        (e) => e.requestValue == model.payer,
        orElse: () => Payer.recipient,
      ),

      agreeTerms: true,

      detail: DetailEntity(
        pickupDate: model.pickupDate,
        pickupSession: model.pickupTimeSlot != null
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
        commodityType: model.commodityType,
        handlingType: model.handlingType,
        note: model.note,
      ),

      selectedProducts: model.items
          .map(
            (e) => SelectedProductEntity(
              id: e.productId ?? e.id ?? "",
              name: e.productName ?? "",
              sku: e.productSku ?? "",
              price: e.unitPrice,
              quantity: e.quantity,
            ),
          )
          .toList(),

      router: RoutingEntity(
        distance: model.distance != null
            ? double.tryParse(model.distance!)
            : null,
        orderCoordinates: (model.coordinates?.coordinates?.length ?? 0) >= 2
            ? model.coordinates!.coordinates!
            : [],
      ),

      hospitalMetadata: model.hospitalMetadata?.toCreateOrderMetadata(),
    );
  }
}

@freezed
abstract class HospitalMetadataEntity with _$HospitalMetadataEntity {
  const HospitalMetadataEntity._();

  const factory HospitalMetadataEntity({
    String? medicalRecordCode,
    String? prescriptionDate,
    String? prescriptionNumber,
    String? delegateName,
    String? delegatePhone,
  }) = _HospitalMetadataEntity;

  factory HospitalMetadataEntity.forToday({
    required String medicalRecordCode,
    required String prescriptionNumber,
    String? delegateName,
    String? delegatePhone,
    DateTime? now,
  }) {
    return HospitalMetadataEntity(
      medicalRecordCode: medicalRecordCode.trim(),
      prescriptionDate: _formatRequestDate(now ?? DateTime.now()),
      prescriptionNumber: prescriptionNumber.trim(),
      delegateName: delegateName?.trim(),
      delegatePhone: delegatePhone?.trim(),
    );
  }

  bool get hasRequiredInfo {
    return medicalRecordCode?.trim().isNotEmpty == true &&
        prescriptionDate?.trim().isNotEmpty == true &&
        prescriptionNumber?.trim().isNotEmpty == true;
  }

  HospitalMetadata toDto() {
    return HospitalMetadata(
      medicalRecordCode: medicalRecordCode,
      prescriptionDate: prescriptionDate,
      prescriptionNumber: prescriptionNumber,
      delegateName: delegateName?.trim().isEmpty == true ? null : delegateName,
      delegatePhone: delegatePhone?.trim().isEmpty == true
          ? null
          : delegatePhone,
    );
  }

  static String _formatRequestDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

extension OrderDetailHospitalMetadataMapper
    on OrderDetailHospitalMetadataEntity {
  HospitalMetadataEntity toCreateOrderMetadata() {
    return HospitalMetadataEntity(
      medicalRecordCode: medicalRecordCode,
      prescriptionDate: prescriptionDate,
      prescriptionNumber: prescriptionNumber,
      delegateName: delegateName,
      delegatePhone: delegatePhone,
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
    @Default([]) List<String> commodityType,
    @Default([]) List<String> handlingType,
    int? length,
    int? width,
    int? height,
    String? orderSource,
    String? note,
  }) = _DetailEntity;

  Detail toDto() {
    return Detail(
      // pickupDate: pickupDate,
      // pickupTimeSlot: pickupSession?.requestValue,
      // deliveryTimeSlot: deliveryTimeSlot,
      weight: weight,
      // isHighValueGoods: isHighValueGoods,
      // isFragile: isFragile,
      // isOnePiece: isOnePiece,
      // isLiquid: isLiquid,
      // hasBattery: hasBattery,
      commodityType: commodityType,
      handlingType: handlingType,
      // length: length ?? 0,
      // width: width ?? 0,
      // height: height ?? 0,
      // orderSource: orderSource,
      note: note,
    );
  }
}
