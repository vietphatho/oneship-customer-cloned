import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/order_tracking/domain/entities/order_tracking_entity.dart';

part 'order_tracking_state.freezed.dart';

@freezed
abstract class OrderTrackingState with _$OrderTrackingState {
  factory OrderTrackingState({
    required Resource<OrderTrackingEntity?> trackingResult,
  }) = _OrderTrackingState;
}
