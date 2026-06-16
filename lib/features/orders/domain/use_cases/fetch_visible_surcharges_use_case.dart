import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class FetchVisibleSurchargesUseCase {
  FetchVisibleSurchargesUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Resource<List<SurchargeGroupEntity>>> call({required String shopId}) {
    return _repository.fetchVisibleSurcharges(shopId: shopId);
  }
}
