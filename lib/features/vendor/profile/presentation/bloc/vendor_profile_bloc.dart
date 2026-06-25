import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/profile/domain/entities/vendor_profile_entity.dart';
import 'package:oneship_customer/features/vendor/profile/domain/use_cases/fetch_vendor_profile_use_case.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_event.dart';
import 'package:oneship_customer/features/vendor/profile/presentation/bloc/vendor_profile_state.dart';

@lazySingleton
class VendorProfileBloc extends Bloc<VendorProfileEvent, VendorProfileState> {
  VendorProfileBloc(this._fetchVendorProfileUseCase)
    : super(VendorProfileState.initial()) {
    on<VendorProfileInitEvent>(_onInit);
    on<VendorProfileClearedEvent>(_onCleared);
  }

  final FetchVendorProfileUseCase _fetchVendorProfileUseCase;

  VendorProfileEntity? get profile => state.profile;

  FutureOr<void> _onInit(
    VendorProfileInitEvent event,
    Emitter<VendorProfileState> emit,
  ) async {
    if (!event.forceRefresh) {
      final currentResource = state.profileResource;
      if (state.hasRequestedProfile &&
          (currentResource.state == Result.loading ||
              currentResource.data != null)) {
        return;
      }
    }

    emit(
      state.copyWith(
        profileResource: Resource.loading(data: state.profileResource.data),
        hasRequestedProfile: true,
      ),
    );

    final response = await _fetchVendorProfileUseCase();
    emit(state.copyWith(profileResource: response));
  }

  FutureOr<void> _onCleared(
    VendorProfileClearedEvent event,
    Emitter<VendorProfileState> emit,
  ) {
    emit(VendorProfileState.initial());
  }

  void init({bool forceRefresh = false}) {
    add(VendorProfileInitEvent(forceRefresh: forceRefresh));
  }

  void refresh() {
    init(forceRefresh: true);
  }

  void clear() {
    add(const VendorProfileClearedEvent());
  }
}
