import 'package:oneship_customer/core/base/base_repository.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';

abstract class VendorProfileRepository extends BaseRepository {
  Future<Resource<VendorProfileEntity>> fetchVendorProfile();
}
