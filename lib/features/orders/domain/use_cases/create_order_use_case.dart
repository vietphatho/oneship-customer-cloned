import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class CreateOrderUseCase {
  const CreateOrderUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Resource> call(CreateOrderRequestEntity request) {
    return _repository.createOrder(request.toDto());
  }
}
