import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/datasources/orders_api.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_order_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/create_product_request.dart';
import 'package:oneship_customer/features/orders/data/models/request/validate_ord_at_hub_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/products_list_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl extends OrdersRepository {
  final OrdersApi _ordersApi;

  OrdersRepositoryImpl(this._ordersApi);

  @override
  Future<Resource<OrdersListResponse>> fetchOrdersByStatus({
    required OrderStatus status,
    required String shopId,
    int page = Constants.defaultPage,
    int limit = Constants.defaultLimitPerPage,
  }) {
    return request(
      () => _ordersApi.fetchOrdersByStatus(
        status: status == OrderStatus.allProcessing ? null : status.value,
        shopId: shopId,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<Resource> createOrder(CreateOrderRequest requestBody) {
    return request(() => _ordersApi.createOrder(requestBody));
  }

  @override
  Future<Resource<CalculatedDeliveryFeeEntity>> calculateDeliveryFee(
    CalculateDeliveryFeeRequest requestBody,
  ) async {
    final response = await request(
      () => _ordersApi.calculateDeliveryFee(requestBody),
    );
    return response.parse<CalculatedDeliveryFeeEntity>(
      (e) => CalculatedDeliveryFeeEntity.from(e),
    );
  }

  @override
  Future<Resource<List<SurchargeGroupEntity>>> fetchVisibleSurcharges({
    required String shopId,
  }) async {
    final response = await request(
      () => _ordersApi.fetchVisibleSurcharges(shopId: shopId),
    );

    return response.parse<List<SurchargeGroupEntity>>((dto) {
      return dto.data.map((e) => SurchargeGroupEntity.from(e)).toList();
    });
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

  @override
  Future<Resource<OrdersHistoryResponseEntity>> fetchOrderHistory({
    required OrderStatus status,
    required String shopId,
    int page = Constants.defaultPage,
    int limit = Constants.defaultLimitPerPage,
  }) async {
    final response = await request(
      () => _ordersApi.fetchOrderHistory(
        status: status == OrderStatus.allProcessing ? null : status.value,
        shopId: shopId,
        page: page,
        limit: limit,
      ),
    );
    return response.parse((dto) => OrdersHistoryResponseEntity.fromDto(dto));
  }

  @override
  Future<Resource<ProductsListEntity>> fetchProductsList({
    required String shopId,
    String? cursor,
    int? limit,
  }) async {
    final response = await request(
      () => _ordersApi.fetchProductsList(
        shopId: shopId,
        cursor: cursor,
        limit: limit,
      ),
    );
    return response.parse((dto) => ProductsListEntity.from(dto));
  }

  @override
  Future<Resource<ProductEntity>> createProduct({
    required String shopId,
    required CreateProductRequest body,
  }) async {
    final response = await request(
      () => _ordersApi.createProduct(shopId: shopId, body: body),
    );
    return response.parse((dto) => ProductEntity.from(dto));
  }

  @override
  Future<Resource> updateOrder({
    required String ordId,
    required CreateOrderRequest requestBody,
  }) {
    return request(
      () => _ordersApi.updateOrder(ordId: ordId, body: requestBody),
    );
  }

  @override
  Future<Resource> validateOrdAtHub({
    required String hubId,
    required ValidateOrdAtHubRequest body,
  }) {
    return request(() => _ordersApi.validateOrdAtHub(hubId: hubId, body: body));
  }
}
