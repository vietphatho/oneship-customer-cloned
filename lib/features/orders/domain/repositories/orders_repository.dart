import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_product_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/calculate_delivery_fee_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/products_list_entity.dart';

abstract class OrdersRepository extends BaseRepository {
  Future<Resource<OrdersListResponse>> fetchOrdersByStatus({
    required OrderStatus status,
    required String shopId,
    int page = 1,
    int limit = Constants.defaultLimitPerPage,
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

  Future<Resource> updateOrder({
    required String ordId,
    required CreateOrderRequest requestBody,
  });

  Future<Resource> deleteOrder({
    required String orderId,
    required String shopId,
    required String status,
  });

  Future<Resource<OrdersHistoryEntity>> fetchOrderHistory({
    required OrderStatus status,
    required String shopId,
  });

  Future<Resource<ProductsListEntity>> fetchProductsList({
    required String shopId,
    String? cursor,
    int? limit,
  });

  Future<Resource<ProductEntity>> createProduct({
    required String shopId,
    required CreateProductRequest body
  });
}
