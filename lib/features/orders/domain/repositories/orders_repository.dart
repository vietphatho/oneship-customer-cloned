import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';

abstract class OrdersRepository extends BaseRepository {
  Future<Resource<OrdersListResponse>> fetchOrdersByStatus({
    required OrderStatus status,
    required String shopId,
  });

  Future<Resource<OrderDetailEntity>> fetchOrderDetail({
    required String shopId,
    required String orderId,
  });

  Future<Resource<GetRoutingToShopResponse>> getRoutingToShop({
    required LatLong shopCoordinates,
    required String destinationRefId,
  });

  Future<Resource<CalculateDeliveryFeeResponse>> calculateDeliveryFee(
    CalculateDeliveryFeeRequest requestBody,
  );

  Future<Resource> createOrder(CreateOrderRequest requestBody);

  Future<Resource> deleteOrder({
    required String orderId,
    required String shopId,
    required String status,
  });

  Future<Resource<OrdersHistoryEntity>> fetchOrderHistory({
    required OrderStatus status,
    required String shopId,
    int page = Constants.defaultPage,
    int limit = Constants.defaultLimit,
  });
}
