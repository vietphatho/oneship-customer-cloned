import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_error.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/profile/data/data_sources/vendor_profile_api.dart';
import 'package:oneship_customer/features/vendor/profile/data/models/response/vendor_profile_response.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';
import 'package:oneship_customer/features/vendor/profile/domain/repositories/vendor_profile_repository.dart';

@LazySingleton(as: VendorProfileRepository)
class VendorProfileRepositoryImpl extends VendorProfileRepository {
  VendorProfileRepositoryImpl(this._api);

  final VendorProfileApi _api;

  @override
  Future<Resource<VendorProfileEntity>> fetchVendorProfile() async {
    final response = await request<VendorProfileResponse, BaseError>(
      _api.fetchVendorProfile,
    );

    return response.parse(VendorProfileEntity.fromDto);
  }
}
