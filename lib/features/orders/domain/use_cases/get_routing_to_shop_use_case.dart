import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/lat_long.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';

@lazySingleton
class GetRoutingToShopUseCase {
  const GetRoutingToShopUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Resource<GetRoutingToShopResponse>> call({
    required LatLong shopCoordinates,
    required String destinationRefId,
  }) {
    return _repository.getRoutingToShop(
      shopCoordinates: shopCoordinates,
      destinationRefId: destinationRefId,
    );
  }
}
