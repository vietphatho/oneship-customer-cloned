import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/constants.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchOrdersByStatusUseCase {
  final OrdersRepository _repository;

  FetchOrdersByStatusUseCase(this._repository);

  Future<Resource<OrdersListResponse>> call({
    required OrderStatus status,
    required String shopId,
    int page = 1,
    int limit = Constants.defaultLimitPerPage,
  }) {
    return _repository.fetchOrdersByStatus(
      status: status,
      shopId: shopId,
      page: page,
      limit: limit,
    );
  }
}
