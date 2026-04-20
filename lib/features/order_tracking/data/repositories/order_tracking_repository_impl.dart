import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/data/data_sources/order_tracking_api.dart';
import 'package:oneship_customer/features/order_tracking/data/models/request/order_tracking_request.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/domain/repositories/order_tracking_repository.dart';

@LazySingleton(as: OrderTrackingRepository)
class OrderTrackingRepositoryImpl extends OrderTrackingRepository {
  final OrderTrackingApi _orderTrackingApi;

  OrderTrackingRepositoryImpl(this._orderTrackingApi);

  @override
  Future<Resource<OrderTrackingEntity>> trackingOrder(
    String orderNumber,
  ) async {
    OrderTrackingRequest body = OrderTrackingRequest(search: orderNumber);
    final response = await request(() => _orderTrackingApi.trackingOrder(body));
    return response.parse<OrderTrackingEntity>(
      (dto) => OrderTrackingEntity.from(dto),
    );
  }
}
