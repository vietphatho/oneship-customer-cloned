import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';

part 'vendor_profile_state.freezed.dart';

@freezed
abstract class VendorProfileState with _$VendorProfileState {
  const factory VendorProfileState({
    required Resource<VendorProfileEntity> profileResource,
    @Default(false) bool hasRequestedProfile,
  }) = _VendorProfileState;

  factory VendorProfileState.initial() =>
      VendorProfileState(profileResource: Resource.loading());
}

extension VendorProfileStateX on VendorProfileState {
  VendorProfileEntity? get profile => profileResource.data;

  bool get hasProfile => profileResource.data != null;

  bool get isLoading => profileResource.state == Result.loading;
}
