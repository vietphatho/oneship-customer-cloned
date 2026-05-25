import 'package:oneship_shop/core/base/base_repository.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/orders/domain/entities/shipper_info_entity.dart';

abstract class ShipperRepository extends BaseRepository {
  Future<Resource<ShipperInfoEntity>> getShipperByCode(String code);
}
