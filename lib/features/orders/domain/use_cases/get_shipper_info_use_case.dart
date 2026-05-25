import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/domain/entities/shipper_info_entity.dart';
import 'package:oneship_shop/features/orders/domain/repositories/shipper_repository.dart';

@lazySingleton
class GetShipperInfoUseCase {
  final ShipperRepository _repository;

  GetShipperInfoUseCase(this._repository);

  Future<Resource<ShipperInfoEntity>> call(String shipperCode) async {
    return _repository.getShipperByCode(shipperCode);
  }
}
