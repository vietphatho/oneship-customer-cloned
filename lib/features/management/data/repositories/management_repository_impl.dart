import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/management/data/datasources/management_api.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';
import 'package:oneship_customer/features/management/domain/repositories/management_repository.dart';

@LazySingleton(as: ManagementRepository)
class ManagementRepositoryImpl extends ManagementRepository {
  final ManagementApi _managementApi;

  ManagementRepositoryImpl(this._managementApi);

  @override
  Future<Resource<GetShopsResponse>> getShops(String userId) {
    return request(() => _managementApi.getShops(userId));
  }
}
