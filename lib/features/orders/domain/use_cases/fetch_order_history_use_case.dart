import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchOrderHistoryUseCase {
  final OrdersRepository _repository;

  FetchOrderHistoryUseCase(this._repository);

  Future<Resource<OrdersHistoryEntity>> call({
    required OrderStatus status,
    required String shopId,
  }) {
    return _repository.fetchOrderHistory(status: status, shopId: shopId);
  }
}
