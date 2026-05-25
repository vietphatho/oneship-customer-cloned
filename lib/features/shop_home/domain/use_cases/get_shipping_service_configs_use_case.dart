import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@injectable
class GetShippingServiceConfigsUseCase {
  final ShopRepository _repository;

  GetShippingServiceConfigsUseCase(this._repository);

  Future<Resource<List<ShippingServiceConfigEntity>>> call({
    required String shopId,
  }) {
    return _repository.getShippingServiceConfigs(shopId: shopId);
  }
}
