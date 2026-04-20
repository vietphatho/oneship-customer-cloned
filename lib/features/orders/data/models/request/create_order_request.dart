import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';

part 'create_order_request.freezed.dart';
part 'create_order_request.g.dart';

@freezed
abstract class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    @JsonKey(name: "externalOrderId") String? externalOrderId,
    @JsonKey(name: "serviceCode") String? serviceCode,
    @JsonKey(name: "codAmount") int? codAmount,
    @JsonKey(name: "deliveryFee") int? deliveryFee,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "fullAddress") String? fullAddress,
    @JsonKey(name: "wardCode") String? wardCode,
    @JsonKey(name: "wardName") String? wardName,
    @JsonKey(name: "provinceCode") String? provinceCode,
    @JsonKey(name: "provinceName") String? provinceName,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "customerName") String? customerName,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "orderItems") String? orderItems,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
    @JsonKey(name: "packageType") String? packageType,
    @JsonKey(name: "shopId") String? shopId,
    @JsonKey(name: "payer") String? payer,
    @JsonKey(name: "agreeTerms") bool? agreeTerms,
    @JsonKey(name: "surcharges") List<dynamic>? surcharges,
    @JsonKey(name: "isNewAddress") @Default(true) bool isNewAddress,
    @JsonKey(name: "detail") Detail? detail,
    @JsonKey(name: "router") Router? router,
    @JsonKey(name: "fullAddressOld") String? fullAddressOld,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  factory CreateOrderRequest.empty() {
    return const CreateOrderRequest(detail: Detail(), router: Router());
  }

  factory CreateOrderRequest.create({
    required String fullAddress,
    required String phone,
    required String customerName,
    required String shopId,

    int? codAmount,
    int? deliveryFee,

    String? wardCode,
    String? wardName,
    String? provinceCode,
    String? provinceName,

    String? email,
    String? note,

    int? weight,
    int? length,
    int? width,
    int? height,

    DateTime? pickupDate,

    LatLong? coordinates,
  }) {
    return CreateOrderRequest(
      fullAddress: fullAddress,
      phone: phone,
      customerName: customerName,
      shopId: shopId,

      codAmount: codAmount ?? 0,
      deliveryFee: deliveryFee ?? 0,

      wardCode: wardCode,
      wardName: wardName,
      provinceCode: provinceCode,
      provinceName: provinceName,

      email: email,
      agreeTerms: true,

      detail: Detail(
        pickupDate: pickupDate ?? DateTime.now(),
        weight: weight ?? 0,
        length: length ?? 0,
        width: width ?? 0,
        height: height ?? 0,
        note: note,
      ),

      router:
          coordinates == null
              ? null
              : Router(
                orderCoordinates: [coordinates.long ?? 0, coordinates.lat ?? 0],
                fullRouteData: FullRouteData(
                  orderCoordinates: [
                    coordinates.long ?? 0,
                    coordinates.lat ?? 0,
                  ],
                ),
              ),
    );
  }
}

@freezed
abstract class Detail with _$Detail {
  const factory Detail({
    @JsonKey(name: "pickupDate") DateTime? pickupDate,
    @JsonKey(name: "pickupTimeSlot") String? pickupTimeSlot,
    @JsonKey(name: "deliveryTimeSlot") String? deliveryTimeSlot,
    @JsonKey(name: "weight") int? weight,
    @JsonKey(name: "length") @Default(0) int length,
    @JsonKey(name: "width") @Default(0) int width,
    @JsonKey(name: "height") @Default(0) int height,
    @JsonKey(name: "orderSource") String? orderSource,
    @JsonKey(name: "note") String? note,
  }) = _Detail;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
}

@freezed
abstract class Router with _$Router {
  const factory Router({
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "orderCoordinates") List<double>? orderCoordinates,
    @JsonKey(name: "fullRouteData") FullRouteData? fullRouteData,
    @JsonKey(name: "id") String? id,
  }) = _Router;

  factory Router.fromJson(Map<String, dynamic> json) => _$RouterFromJson(json);
}

@freezed
abstract class FullRouteData with _$FullRouteData {
  const factory FullRouteData({
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "weight") double? weight,
    @JsonKey(name: "time") int? time,
    @JsonKey(name: "transfers") int? transfers,
    @JsonKey(name: "points_encoded") bool? pointsEncoded,
    @JsonKey(name: "bbox") List<double>? bbox,
    @JsonKey(name: "snapped_waypoints") BaseCoordinates? snappedWaypoints,
    @JsonKey(name: "points") BaseCoordinates? points,
    @JsonKey(name: "instructions") List<Instruction>? instructions,
    @JsonKey(name: "orderCoordinates") List<double>? orderCoordinates,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "ward") String? ward,
    @JsonKey(name: "city") String? city,
  }) = _FullRouteData;

  factory FullRouteData.fromJson(Map<String, dynamic> json) =>
      _$FullRouteDataFromJson(json);
}

@freezed
abstract class Instruction with _$Instruction {
  const factory Instruction({
    @JsonKey(name: "distance") double? distance,
    @JsonKey(name: "heading") double? heading,
    @JsonKey(name: "sign") int? sign,
    @JsonKey(name: "interval") List<int>? interval,
    @JsonKey(name: "text") String? text,
    @JsonKey(name: "time") int? time,
    @JsonKey(name: "street_name") String? streetName,
    @JsonKey(name: "last_heading") double? lastHeading,
  }) = _Instruction;

  factory Instruction.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);
}
