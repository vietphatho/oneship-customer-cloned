import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';

abstract class OrderTrackingState {
  const OrderTrackingState({required this.trackingResult});

  final Resource<OrderTrackingEntity> trackingResult;
}

class OrderTrackingInitState extends OrderTrackingState {
  const OrderTrackingInitState({required super.trackingResult});
}
