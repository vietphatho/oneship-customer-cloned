import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchVisibleSurchargesUseCase {
  FetchVisibleSurchargesUseCase(this._repository);

  final ShopRepository _repository;

  Future<Resource<List<SurchargeGroupEntity>>> call({required String shopId}) {
    return _repository.fetchVisibleSurcharges(shopId: shopId);
  }
}
