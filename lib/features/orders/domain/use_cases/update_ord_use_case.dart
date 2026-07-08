import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class UpdateOrdUseCase {
  final OrdersRepository _repository;

  UpdateOrdUseCase(this._repository);

  Future<Resource> call({
    required String ordId,
    required CreateOrderRequestEntity request,
  }) async {
    final cleanRequest = request.copyWith(
      paymentStatus: null,
      paymentMethod: null,
      status: null,
      orderNumber: null,
      selectedProducts: request.selectedProducts
          .where((product) => product.id.isNotEmpty)
          .toList(),
    );
    return _repository.updateOrder(
      ordId: ordId,
      requestBody: cleanRequest.toDto(),
    );
  }
}
