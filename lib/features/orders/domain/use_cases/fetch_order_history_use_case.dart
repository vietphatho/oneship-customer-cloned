import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/constants/constants.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/data/enum.dart';
import 'package:oneship_shop/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_shop/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchOrderHistoryUseCase {
  final OrdersRepository _repository;

  FetchOrderHistoryUseCase(this._repository);

  Future<Resource<OrdersHistoryResponseEntity>> call({
    required OrderStatus status,
    required String shopId,
    int page = Constants.defaultPage,
    int limit = Constants.defaultLimitPerPage,
  }) {
    return _repository.fetchOrderHistory(
      status: status,
      shopId: shopId,
      page: page,
      limit: limit,
    );
  }
}
