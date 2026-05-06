import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';

part 'routing_entity.freezed.dart';

@freezed
abstract class RoutingEntity with _$RoutingEntity {
  const RoutingEntity._();

  const factory RoutingEntity({
    String? id,
    double? distance,
    @Default([]) List<double> orderCoordinates,
    FullRouteDataEntity? fullRouteData,
  }) = _RoutingEntity;

  factory RoutingEntity.from(GetRoutingToShopResponse dto) {
    return RoutingEntity(
      id: dto.id,
      distance: dto.distance,
      orderCoordinates: dto.orderCoordinates ?? [],
      fullRouteData:
          dto.fullRouteData != null
              ? FullRouteDataEntity.from(dto.fullRouteData!)
              : null,
    );
  }

  GetRoutingToShopResponse toDto() {
    return GetRoutingToShopResponse(
      id: id,
      distance: distance,
      orderCoordinates: orderCoordinates,
      fullRouteData: fullRouteData?.toDto(),
    );
  }
}

@freezed
abstract class FullRouteDataEntity with _$FullRouteDataEntity {
  const FullRouteDataEntity._();

  const factory FullRouteDataEntity({
    double? distance,
    double? weight,
    int? time,
    int? transfers,
    bool? pointsEncoded,
    @Default([]) List<double> bbox,
    PointsEntity? snappedWaypoints,
    PointsEntity? points,
    @Default([]) List<InstructionEntity> instructions,
    @Default([]) List<double> orderCoordinates,
    String? address,
    String? ward,
    String? city,
  }) = _FullRouteDataEntity;

  factory FullRouteDataEntity.from(FullRouteData dto) {
    return FullRouteDataEntity(
      distance: dto.distance,
      weight: dto.weight,
      time: dto.time,
      transfers: dto.transfers,
      pointsEncoded: dto.pointsEncoded,
      bbox: dto.bbox ?? [],
      snappedWaypoints:
          dto.snappedWaypoints != null
              ? PointsEntity.from(dto.snappedWaypoints!)
              : null,
      points: dto.points != null ? PointsEntity.from(dto.points!) : null,
      instructions:
          dto.instructions?.map((e) => InstructionEntity.from(e)).toList() ??
          [],
      orderCoordinates: dto.orderCoordinates ?? [],
      address: dto.address,
      ward: dto.ward,
      city: dto.city,
    );
  }

  FullRouteData toDto() {
    return FullRouteData(
      distance: distance,
      weight: weight,
      time: time,
      transfers: transfers,
      pointsEncoded: pointsEncoded,
      bbox: bbox,
      snappedWaypoints: snappedWaypoints?.toDto(),
      points: points?.toDto(),
      instructions: instructions.map((e) => e.toDto()).toList(),
      orderCoordinates: orderCoordinates,
      address: address,
      ward: ward,
      city: city,
    );
  }
}

@freezed
abstract class InstructionEntity with _$InstructionEntity {
  const InstructionEntity._();

  const factory InstructionEntity({
    double? distance,
    double? heading,
    int? sign,
    @Default([]) List<int> interval,
    String? text,
    int? time,
    String? streetName,
    double? lastHeading,
  }) = _InstructionEntity;

  factory InstructionEntity.from(Instruction dto) {
    return InstructionEntity(
      distance: dto.distance,
      heading: dto.heading,
      sign: dto.sign,
      interval: dto.interval ?? [],
      text: dto.text,
      time: dto.time,
      streetName: dto.streetName,
      lastHeading: dto.lastHeading,
    );
  }

  Instruction toDto() {
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

@freezed
abstract class PointsEntity with _$PointsEntity {
  const PointsEntity._();

  const factory PointsEntity({
    String? type,
    @Default([]) List<List<double>> coordinates,
  }) = _PointsEntity;

  factory PointsEntity.from(Points dto) {
    return PointsEntity(type: dto.type, coordinates: dto.coordinates ?? []);
  }

  Points toDto() {
    return Points(type: type, coordinates: coordinates);
  }
}
