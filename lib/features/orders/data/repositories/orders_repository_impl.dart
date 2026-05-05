import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/datasources/orders_api.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl extends OrdersRepository {
  final OrdersApi _ordersApi;

  OrdersRepositoryImpl(this._ordersApi);

  @override
  Future<Resource<OrdersListResponse>> fetchOrdersByStatus({
    required OrderStatus status,
    required String shopId,
  }) {
    return request(
      () =>
          _ordersApi.fetchOrdersByStatus(status: status.value, shopId: shopId),
    );
  }

  @override
  Future<Resource> createOrder(CreateOrderRequest requestBody) {
    return request(() => _ordersApi.createOrder(requestBody));
  }

  @override
  Future<Resource<CalculateDeliveryFeeResponse>> calculateDeliveryFee(
    CalculateDeliveryFeeRequest requestBody,
  ) {
    return request(() => _ordersApi.calculateDeliveryFee(requestBody));
  }

  @override
  Future<Resource<GetRoutingToShopResponse>> getRoutingToShop({
    required LatLong shopCoordinates,
    required String destinationRefId,
  }) {
    return request(
      () => _ordersApi.getRoutingToShop(
        coordinates: [shopCoordinates.long ?? 0, shopCoordinates.lat ?? 0],
        destinationRefId: destinationRefId,
        vehicle: Constants.vehicleDefault,
      ),
    );
  }

  @override
  Future<Resource<OrderDetailEntity>> fetchOrderDetail({
    required String shopId,
    required String orderId,
  }) async {
    final response = await request(
      () => _ordersApi.fetchOrderDetail(shopId: shopId, orderId: orderId),
    );
    return response.parse((dto) => OrderDetailEntity.from(dto));
  }

  @override
  Future<Resource> deleteOrder({
    required String orderId,
    required String shopId,
    required String status,
  }) {
    return request(
      () => _ordersApi.deleteOrder(
        orderId: orderId,
        shopId: shopId,
        status: status,
      ),
    );
  }
}
