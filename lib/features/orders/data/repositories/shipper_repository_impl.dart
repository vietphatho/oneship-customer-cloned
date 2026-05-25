import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/data/datasources/shipper_api.dart';
import 'package:oneship_shop/features/orders/domain/entities/shipper_info_entity.dart';
import 'package:oneship_shop/features/orders/domain/repositories/shipper_repository.dart';

@LazySingleton(as: ShipperRepository)
class ShipperRepositoryImpl extends ShipperRepository {
  final ShipperApi _api;

  ShipperRepositoryImpl(this._api);

  @override
  Future<Resource<ShipperInfoEntity>> getShipperByCode(String code) async {
    final response = await request(() => _api.getShipperByCode(code));
    return response.parse((dto) => ShipperInfoEntity.fromDto(dto));
  }
}
