import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchOrderDetailUseCase {
  final OrdersRepository _repository;

  FetchOrderDetailUseCase(this._repository);

  Future<Resource<OrderDetailEntity>> call({
    required String shopId,
    required String orderId,
  }) {
    return _repository.fetchOrderDetail(shopId: shopId, orderId: orderId);
  }
}
