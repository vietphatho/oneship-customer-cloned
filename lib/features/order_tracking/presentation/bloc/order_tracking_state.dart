import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';

part 'order_tracking_state.freezed.dart';

@freezed
abstract class OrderTrackingState with _$OrderTrackingState {
  factory OrderTrackingState({Resource<OrderTrackingEntity>? trackingResult}) =
      _OrderTrackingState;
}