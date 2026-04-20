import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_event.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_state.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/location_service/data/repositories/location_service_repository.dart';

@lazySingleton
class LocationServiceBloc
    extends Bloc<LocationServiceEvent, LocationServiceState> {
  LocationServiceBloc(this._repository)
    : super(LocationServiceProvincesChangedState(filteredProvinces: [])) {
    on<LocationServiceInitEvent>(_onInit);
    on<LocationServiceSearchProvincesEvent>(_onProvincesSearchEvent);
    on<LocationServiceSearchWardsEvent>(_onWardsSearchEvent);
    on<LocationServiceSearchAddressEvent>(_onSearchAddressEvent);
  }

  final LocationServiceRepository _repository;

  FutureOr<void> _onInit(
    LocationServiceInitEvent event,
    Emitter<LocationServiceState> emit,
  ) async {
    final _provinces = await _repository.fetchProvinces();
    final _wardsByProvince = await _repository.initWardsByProvince();
    emit(
      LocationServiceProvincesChangedState(
        provinces: _provinces,
        wardsByProvince: _wardsByProvince,
        filteredProvinces: _provinces,
      ),
    );
  }

  Future<void> _onProvincesSearchEvent(
    LocationServiceSearchProvincesEvent event,
    Emitter<LocationServiceState> emit,
  ) async {
    var result =
        state.provinces
            .where(
              (p) => p.name.toLowerCase().contains(event.keyword.toLowerCase()),
            )
            .toList();
    emit(
      LocationServiceProvincesChangedState(
        provinces: state.provinces,
        wardsByProvince: state.wardsByProvince,
        filteredProvinces: result,
      ),
    );
  }

  Future<void> _onWardsSearchEvent(
    LocationServiceSearchWardsEvent event,
    Emitter<LocationServiceState> emit,
  ) async {
    final wards = state.wardsByProvince[event.province.code.toString()] ?? [];
    var result =
        wards
            .where(
              (w) => w.name.toLowerCase().contains(event.keyword.toLowerCase()),
            )
            .toList();
    emit(
      LocationServiceWardsChangedState(
        provinces: state.provinces,
        wardsByProvince: state.wardsByProvince,
        filteredWards: result,
      ),
    );
  }

  @PostConstruct()
  void init() {
    add(LocationServiceInitEvent());
  }

  void reset() {
    add(LocationServiceSearchProvincesEvent(""));
  }

  void searchProvince(String keyword) {
    add(LocationServiceSearchProvincesEvent(keyword));
  }

  void searchWard(String keyword, {required Province province}) {
    add(LocationServiceSearchWardsEvent(keyword: keyword, province: province));
  }

  Future<List<SuggestedAddressResponse>> searchAddress({
    required Province province,
    required Ward ward,
    String address = "",
  }) async {
    final resource = await _repository.searchAddress(
      provinceName: province.name,
      provinceCode: province.code,
      wardName: ward.name,
      wardCode: ward.code,
      address: address,
    );
    return resource.data ?? [];
  }

  FutureOr<void> _onSearchAddressEvent(
    LocationServiceSearchAddressEvent event,
    Emitter<LocationServiceState> emit,
  ) async {
    // emit(
    //   LocationServiceSearchAddressState(Resource.loading())

    // );
  }
}
