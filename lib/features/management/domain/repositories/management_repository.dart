import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';

abstract class ManagementRepository extends BaseRepository {
  Future<Resource<GetShopsResponse>> getShops(String userId);
}
