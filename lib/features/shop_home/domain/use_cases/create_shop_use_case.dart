import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/create_shop_params.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class CreateShopUseCase {
  CreateShopUseCase(this._repository);

  final ShopRepository _repository;

  Future<Resource<CreateShopEntity?>> call(CreateShopParams params) {
    return _repository.createShop(params);
  }
}
