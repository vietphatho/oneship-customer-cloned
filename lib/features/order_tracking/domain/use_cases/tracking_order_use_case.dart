import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/domain/repositories/order_tracking_repository.dart';

@lazySingleton
class TrackingOrderUseCase {
  final OrderTrackingRepository _repository;

  TrackingOrderUseCase(this._repository);

  Future<Resource<OrderTrackingEntity>> trackingOrder(
    String orderNumber,
  ) async {
    final response = await _repository.trackingOrder(orderNumber);
    return response;
  }
}
