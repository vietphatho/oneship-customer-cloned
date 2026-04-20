import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';

abstract class OrderTrackingRepository extends BaseRepository {
  Future<Resource<OrderTrackingEntity>> trackingOrder(String orderNumber);
}
