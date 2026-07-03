import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchHandlingTypesUseCase {
  const FetchHandlingTypesUseCase(this._repository);

  final ShopRepository _repository;

  Future<Resource<List<OrderOptionEntity>>> call({required String shopId}) {
    return _repository.fetchHandlingTypes(shopId: shopId);
  }
}
