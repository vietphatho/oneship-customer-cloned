import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class CalculateDeliveryFeeUseCase {
  const CalculateDeliveryFeeUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Resource<CalculatedDeliveryFeeEntity>> call(
    CalculateDeliveryFeeRequest request,
  ) {
    return _repository.calculateDeliveryFee(request);
  }
}
