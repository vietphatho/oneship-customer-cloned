import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchShopsUseCase {
  final ShopRepository _repository;

  FetchShopsUseCase(this._repository);

  Future<Resource<GetShopsEntity>> call(String userId) {
    return _repository.getShops(userId);
  }
}
