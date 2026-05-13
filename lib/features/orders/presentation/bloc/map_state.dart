import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_map_entity.dart';

part 'map_state.freezed.dart';

enum OrderDetailMapMarkerType { shop, delivery }

@freezed
abstract class OrderDetailMapState with _$OrderDetailMapState {
  const factory OrderDetailMapState({
    @Default(OrderDetailMapEntity()) OrderDetailMapEntity map,
    OrderDetailMapMarkerType? selectedMarker,
  }) = _OrderDetailMapState;
}
