import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/shipper_info_entity.dart';

abstract class ShipperRepository extends BaseRepository {
  Future<Resource<ShipperInfoEntity>> getShipperByCode(String code);
}
