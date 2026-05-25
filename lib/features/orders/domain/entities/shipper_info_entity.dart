import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/features/orders/data/models/response/shipper_info_response.dart';

part 'shipper_info_entity.freezed.dart';

@freezed
abstract class ShipperInfoEntity with _$ShipperInfoEntity {
  const factory ShipperInfoEntity({
    String? shipperCode,
    @Default("") String name,
    String? phone,
    int? rating,
    String? avatarUrl,
  }) = _ShipperInfoEntity;

  factory ShipperInfoEntity.fromDto(ShipperInfoResponse dto) {
    return ShipperInfoEntity(
      shipperCode: dto.shipperCode,
      name: dto.name ?? "",
      phone: dto.phone,
      rating: dto.rating,
      avatarUrl: dto.avatarUrl,
    );
  }
}
