import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class DeleteOrderUseCase {
  final OrdersRepository _repository;

  DeleteOrderUseCase(this._repository);

  Future<Resource> call(OrderInfo order) async {
    return await _repository.deleteOrder(
      shopId: order.shopId!,
      orderId: order.id!,
      status: order.status!,
    );
  }
}
