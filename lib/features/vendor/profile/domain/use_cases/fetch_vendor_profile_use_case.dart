import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';
import 'package:oneship_customer/features/vendor/profile/domain/repositories/vendor_profile_repository.dart';

@lazySingleton
class FetchVendorProfileUseCase {
  FetchVendorProfileUseCase(this._repository);

  final VendorProfileRepository _repository;

  Future<Resource<VendorProfileEntity>> call() {
    return _repository.fetchVendorProfile();
  }
}
