import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';

import '../../data/models/request/create_order_request.dart';

class CreateOrderEntity {
  final String? externalOrderId;
  final DeliveryServiceType serviceCode;
  final int? codAmount;
  final int? deliveryFee;
  final String? status;
  final String? fullAddress;
  final int? wardCode;
  final String? wardName;
  final int? provinceCode;
  final String? provinceName;
  final String recipientPhone;
  final String recipientName;
  final String? email;
  final String? orderItems;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? packageType;
  final String shopId;
  final CreateOrderPayer payer;
  final bool agreeTerms;
  final List<dynamic>? surcharges;
  final bool? isNewAddress;
  final DetailEntity? detail;
  final RouterEntity? router;
  final String? fullAddressOld;

  CreateOrderEntity({
    this.externalOrderId,
    required this.serviceCode,
    this.codAmount,
    this.deliveryFee,
    this.status,
    this.fullAddress,
    this.wardCode,
    this.wardName,
    this.provinceCode,
    this.provinceName,
    required this.recipientPhone,
    required this.recipientName,
    this.email,
    this.orderItems,
    this.paymentStatus,
    this.paymentMethod,
    this.packageType,
    required this.shopId,
    required this.payer,
    required this.agreeTerms,
    this.surcharges,
    this.isNewAddress,
    this.detail,
    this.router,
    this.fullAddressOld,
  });

  factory CreateOrderEntity.empty() => CreateOrderEntity(
    shopId: '',
    payer: CreateOrderPayer.recipient,
    agreeTerms: true,
    recipientPhone: '',
    recipientName: '',
    serviceCode: DeliveryServiceType.standard,
    detail: DetailEntity(),
    router: RouterEntity(),
  );

  factory CreateOrderEntity.create({
    String? externalOrderId,
    required DeliveryServiceType serviceCode,
    int? codAmount,
    int? deliveryFee,
    String? status,
    String? fullAddress,
    int? wardCode,
    String? wardName,
    int? provinceCode,
    String? provinceName,
    required String recipientPhone,
    required String recipientName,
    String? email,
    String? orderItems,
    String? paymentStatus,
    String? paymentMethod,
    String? packageType,
    required String shopId,
    required CreateOrderPayer payer,
    required bool agreeTerms,
    List<dynamic>? surcharges,
    bool? isNewAddress,
    String? fullAddressOld,
    // DetailEntity fields
    DateTime? pickupDate,
    OrderPickUpSession? pickUpSession,
    String? deliveryTimeSlot,
    int? weight,
    int? length,
    int? width,
    int? height,
    String? orderSource,
    String? note,
    // RouterEntity fields
    double? routerDistance,
    List<double>? routerOrderCoordinates,
    String? routerId,
    // FullRouteDataEntity fields
    double? fullRouteDistance,
    double? fullRouteWeight,
    int? fullRouteTime,
    int? fullRouteTransfers,
    bool? fullRoutePointsEncoded,
    List<double>? fullRouteBbox,
    dynamic fullRouteSnappedWaypoints,
    dynamic fullRoutePoints,
    List<InstructionEntity>? fullRouteInstructions,
    List<double>? fullRouteOrderCoordinates,
    String? fullRouteAddress,
    String? fullRouteWard,
    String? fullRouteCity,
  }) {
    return CreateOrderEntity(
      externalOrderId: externalOrderId,
      serviceCode: serviceCode,
      codAmount: codAmount,
      deliveryFee: deliveryFee,
      status: status,
      fullAddress: fullAddress,
      wardCode: wardCode,
      wardName: wardName,
      provinceCode: provinceCode,
      provinceName: provinceName,
      recipientPhone: recipientPhone,
      recipientName: recipientName,
      email: email,
      orderItems: orderItems,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      packageType: packageType,
      shopId: shopId,
      payer: payer,
      agreeTerms: agreeTerms,
      surcharges: surcharges,
      isNewAddress: isNewAddress,
      fullAddressOld: fullAddressOld,
      detail:
          (pickupDate != null ||
                  pickUpSession != null ||
                  deliveryTimeSlot != null ||
                  weight != null ||
                  length != null ||
                  width != null ||
                  height != null ||
                  orderSource != null ||
                  note != null)
              ? DetailEntity(
                pickupDate: pickupDate,
                pickUpSession: pickUpSession,
                deliveryTimeSlot: deliveryTimeSlot,
                weight: weight,
                length: length,
                width: width,
                height: height,
                orderSource: orderSource,
                note: note,
              )
              : null,
      router:
          (routerDistance != null ||
                  routerOrderCoordinates != null ||
                  routerId != null ||
                  fullRouteDistance != null ||
                  fullRouteWeight != null ||
                  fullRouteTime != null ||
                  fullRouteTransfers != null ||
                  fullRoutePointsEncoded != null ||
                  fullRouteBbox != null ||
                  fullRouteSnappedWaypoints != null ||
                  fullRoutePoints != null ||
                  fullRouteInstructions != null ||
                  fullRouteOrderCoordinates != null ||
                  fullRouteAddress != null ||
                  fullRouteWard != null ||
                  fullRouteCity != null)
              ? RouterEntity(
                distance: routerDistance,
                orderCoordinates: routerOrderCoordinates,
                id: routerId,
                fullRouteData:
                    (fullRouteDistance != null ||
                            fullRouteWeight != null ||
                            fullRouteTime != null ||
                            fullRouteTransfers != null ||
                            fullRoutePointsEncoded != null ||
                            fullRouteBbox != null ||
                            fullRouteSnappedWaypoints != null ||
                            fullRoutePoints != null ||
                            fullRouteInstructions != null ||
                            fullRouteOrderCoordinates != null ||
                            fullRouteAddress != null ||
                            fullRouteWard != null ||
                            fullRouteCity != null)
                        ? FullRouteDataEntity(
                          distance: fullRouteDistance,
                          weight: fullRouteWeight,
                          time: fullRouteTime,
                          transfers: fullRouteTransfers,
                          pointsEncoded: fullRoutePointsEncoded,
                          bbox: fullRouteBbox,
                          snappedWaypoints: fullRouteSnappedWaypoints,
                          points: fullRoutePoints,
                          instructions: fullRouteInstructions,
                          orderCoordinates: fullRouteOrderCoordinates,
                          address: fullRouteAddress,
                          ward: fullRouteWard,
                          city: fullRouteCity,
                        )
                        : null,
              )
              : null,
    );
  }

  CreateOrderEntity copyWith({
    String? externalOrderId,
    DeliveryServiceType? serviceCode,
    int? codAmount,
    int? deliveryFee,
    String? status,
    String? fullAddress,
    int? wardCode,
    String? wardName,
    int? provinceCode,
    String? provinceName,
    String? recipientPhone,
    String? recipientName,
    String? email,
    String? orderItems,
    String? paymentStatus,
    String? paymentMethod,
    String? packageType,
    String? shopId,
    CreateOrderPayer? payer,
    bool? agreeTerms,
    List<dynamic>? surcharges,
    bool? isNewAddress,
    DetailEntity? detail,
    RouterEntity? router,
    String? fullAddressOld,
  }) {
    return CreateOrderEntity(
      externalOrderId: externalOrderId ?? this.externalOrderId,
      serviceCode: serviceCode ?? this.serviceCode,
      codAmount: codAmount ?? this.codAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      status: status ?? this.status,
      fullAddress: fullAddress ?? this.fullAddress,
      wardCode: wardCode ?? this.wardCode,
      wardName: wardName ?? this.wardName,
      provinceCode: provinceCode ?? this.provinceCode,
      provinceName: provinceName ?? this.provinceName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      recipientName: recipientName ?? this.recipientName,
      email: email ?? this.email,
      orderItems: orderItems ?? this.orderItems,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      packageType: packageType ?? this.packageType,
      shopId: shopId ?? this.shopId,
      payer: payer ?? this.payer,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      surcharges: surcharges ?? this.surcharges,
      isNewAddress: isNewAddress ?? this.isNewAddress,
      detail: detail ?? this.detail,
      router: router ?? this.router,
      fullAddressOld: fullAddressOld ?? this.fullAddressOld,
    );
  }

  // factory CreateOrderEntity.fromModel(CreateOrderRequest model) {
  //   return CreateOrderEntity(
  //     externalOrderId: model.externalOrderId,
  //     serviceCode: model.serviceCode,
  //     codAmount: model.codAmount,
  //     deliveryFee: model.deliveryFee,
  //     status: model.status,
  //     fullAddress: model.fullAddress,
  //     wardCode: model.wardCode,
  //     wardName: model.wardName,
  //     provinceCode: model.provinceCode,
  //     provinceName: model.provinceName,
  //     recipientPhone: model.phone ?? "",
  //     recipientName: model.customerName ?? "",
  //     email: model.email,
  //     orderItems: model.orderItems,
  //     paymentStatus: model.paymentStatus,
  //     paymentMethod: model.paymentMethod,
  //     packageType: model.packageType,
  //     shopId: model.shopId ?? "",
  //     payer: model.payer,
  //     agreeTerms: model.agreeTerms,
  //     surcharges: model.surcharges,
  //     isNewAddress: model.isNewAddress,
  //     detail:
  //         model.detail == null ? null : DetailEntity.fromModel(model.detail!),
  //     router:
  //         model.router == null ? null : RouterEntity.fromModel(model.router!),
  //     fullAddressOld: model.fullAddressOld,
  //   );
  // }

  CreateOrderRequest toModel() {
    return CreateOrderRequest(
      externalOrderId: externalOrderId,
      serviceCode: serviceCode.requestValue,
      codAmount: codAmount,
      deliveryFee: deliveryFee,
      status: status,
      fullAddress: fullAddress,
      wardCode: wardCode?.toString(),
      wardName: wardName,
      provinceCode: provinceCode?.toString(),
      provinceName: provinceName,
      phone: recipientPhone,
      customerName: recipientName,
      email: email,
      orderItems: orderItems,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      packageType: packageType,
      shopId: shopId,
      payer: payer.requestValue,
      agreeTerms: agreeTerms,
      surcharges: surcharges,
      isNewAddress: isNewAddress ?? true,
      detail: detail?.toModel(),
      router: router?.toModel(),
      fullAddressOld: fullAddressOld,
    );
  }

  Province? get province {
    if (provinceName == null || provinceCode == null) return null;
    return Province(name: provinceName!, code: provinceCode!);
  }

  Ward? get ward {
    if (wardCode == null || wardName == null || provinceCode == null) {
      return null;
    }
    return Ward(name: wardName!, code: wardCode!, provinceCode: provinceCode!);
  }
}

class DetailEntity {
  DetailEntity copyWith({
    DateTime? pickupDate,
    OrderPickUpSession? pickUpSession,
    String? deliveryTimeSlot,
    int? weight,
    int? length,
    int? width,
    int? height,
    String? orderSource,
    String? note,
  }) {
    return DetailEntity(
      pickupDate: pickupDate ?? this.pickupDate,
      pickUpSession: pickUpSession ?? this.pickUpSession,
      deliveryTimeSlot: deliveryTimeSlot ?? this.deliveryTimeSlot,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      orderSource: orderSource ?? this.orderSource,
      note: note ?? this.note,
    );
  }

  final DateTime? pickupDate;
  final OrderPickUpSession? pickUpSession;
  final String? deliveryTimeSlot;
  final int? weight;
  final int? length;
  final int? width;
  final int? height;
  final String? orderSource;
  final String? note;

  DetailEntity({
    this.pickupDate,
    this.pickUpSession,
    this.deliveryTimeSlot,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.orderSource,
    this.note,
  });

  // factory DetailEntity.fromModel(Detail model) {
  //   return DetailEntity(
  //     pickupDate: model.pickupDate,
  //     pickupTimeSlot: model.pickupTimeSlot,
  //     deliveryTimeSlot: model.deliveryTimeSlot,
  //     weight: model.weight,
  //     length: model.length,
  //     width: model.width,
  //     height: model.height,
  //     orderSource: model.orderSource,
  //     note: model.note,
  //   );
  // }

  Detail toModel() {
    return Detail(
      pickupDate: pickupDate,
      pickupTimeSlot: pickUpSession?.requestValue,
      deliveryTimeSlot: deliveryTimeSlot,
      weight: weight,
      length: length ?? 0,
      width: width ?? 0,
      height: height ?? 0,
      orderSource: orderSource,
      note: note,
    );
  }
}

class RouterEntity {
  RouterEntity copyWith({
    double? distance,
    List<double>? orderCoordinates,
    FullRouteDataEntity? fullRouteData,
    String? id,
  }) {
    return RouterEntity(
      distance: distance ?? this.distance,
      orderCoordinates: orderCoordinates ?? this.orderCoordinates,
      fullRouteData: fullRouteData ?? this.fullRouteData,
      id: id ?? this.id,
    );
  }

  final double? distance;
  final List<double>? orderCoordinates;
  final FullRouteDataEntity? fullRouteData;
  final String? id;

  RouterEntity({
    this.distance,
    this.orderCoordinates,
    this.fullRouteData,
    this.id,
  });

  factory RouterEntity.fromModel(Router model) {
    return RouterEntity(
      distance: model.distance,
      orderCoordinates: model.orderCoordinates,
      fullRouteData:
          model.fullRouteData == null
              ? null
              : FullRouteDataEntity.fromModel(model.fullRouteData!),
      id: model.id,
    );
  }

  Router toModel() {
    return Router(
      distance: distance,
      orderCoordinates: orderCoordinates,
      fullRouteData: fullRouteData?.toModel(),
      id: id,
    );
  }
}

class FullRouteDataEntity {
  FullRouteDataEntity copyWith({
    double? distance,
    double? weight,
    int? time,
    int? transfers,
    bool? pointsEncoded,
    List<double>? bbox,
    dynamic snappedWaypoints,
    dynamic points,
    List<InstructionEntity>? instructions,
    List<double>? orderCoordinates,
    String? address,
    String? ward,
    String? city,
  }) {
    return FullRouteDataEntity(
      distance: distance ?? this.distance,
      weight: weight ?? this.weight,
      time: time ?? this.time,
      transfers: transfers ?? this.transfers,
      pointsEncoded: pointsEncoded ?? this.pointsEncoded,
      bbox: bbox ?? this.bbox,
      snappedWaypoints: snappedWaypoints ?? this.snappedWaypoints,
      points: points ?? this.points,
      instructions: instructions ?? this.instructions,
      orderCoordinates: orderCoordinates ?? this.orderCoordinates,
      address: address ?? this.address,
      ward: ward ?? this.ward,
      city: city ?? this.city,
    );
  }

  final double? distance;
  final double? weight;
  final int? time;
  final int? transfers;
  final bool? pointsEncoded;
  final List<double>? bbox;
  final dynamic snappedWaypoints; // BaseCoordinates? => dynamic
  final dynamic points; // BaseCoordinates? => dynamic
  final List<InstructionEntity>? instructions;
  final List<double>? orderCoordinates;
  final String? address;
  final String? ward;
  final String? city;

  FullRouteDataEntity({
    this.distance,
    this.weight,
    this.time,
    this.transfers,
    this.pointsEncoded,
    this.bbox,
    this.snappedWaypoints,
    this.points,
    this.instructions,
    this.orderCoordinates,
    this.address,
    this.ward,
    this.city,
  });

  factory FullRouteDataEntity.fromModel(FullRouteData model) {
    return FullRouteDataEntity(
      distance: model.distance,
      weight: model.weight,
      time: model.time,
      transfers: model.transfers,
      pointsEncoded: model.pointsEncoded,
      bbox: model.bbox,
      snappedWaypoints: model.snappedWaypoints,
      points: model.points,
      instructions:
          model.instructions
              ?.map((e) => InstructionEntity.fromModel(e))
              .toList(),
      orderCoordinates: model.orderCoordinates,
      address: model.address,
      ward: model.ward,
      city: model.city,
    );
  }

  FullRouteData toModel() {
    return FullRouteData(
      distance: distance,
      weight: weight,
      time: time,
      transfers: transfers,
      pointsEncoded: pointsEncoded,
      bbox: bbox,
      snappedWaypoints: snappedWaypoints,
      points: points,
      instructions: instructions?.map((e) => e.toModel()).toList(),
      orderCoordinates: orderCoordinates,
      address: address,
      ward: ward,
      city: city,
    );
  }
}

class InstructionEntity {
  InstructionEntity copyWith({
    double? distance,
    double? heading,
    int? sign,
    List<int>? interval,
    String? text,
    int? time,
    String? streetName,
    double? lastHeading,
  }) {
    return InstructionEntity(
      distance: distance ?? this.distance,
      heading: heading ?? this.heading,
      sign: sign ?? this.sign,
      interval: interval ?? this.interval,
      text: text ?? this.text,
      time: time ?? this.time,
      streetName: streetName ?? this.streetName,
      lastHeading: lastHeading ?? this.lastHeading,
    );
  }

  final double? distance;
  final double? heading;
  final int? sign;
  final List<int>? interval;
  final String? text;
  final int? time;
  final String? streetName;
  final double? lastHeading;

  InstructionEntity({
    this.distance,
    this.heading,
    this.sign,
    this.interval,
    this.text,
    this.time,
    this.streetName,
    this.lastHeading,
  });

  factory InstructionEntity.fromModel(Instruction model) {
    return InstructionEntity(
      distance: model.distance,
      heading: model.heading,
      sign: model.sign,
      interval: model.interval,
      text: model.text,
      time: model.time,
      streetName: model.streetName,
      lastHeading: model.lastHeading,
    );
  }

  Instruction toModel() {
    return Instruction(
      distance: distance,
      heading: heading,
      sign: sign,
      interval: interval,
      text: text,
      time: time,
      streetName: streetName,
      lastHeading: lastHeading,
    );
  }
}
