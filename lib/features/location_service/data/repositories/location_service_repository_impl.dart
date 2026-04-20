import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/location_service/data/datasources/location_service_api.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/location_service/data/repositories/location_service_repository.dart';

@LazySingleton(as: LocationServiceRepository)
class LocationServiceRepositoryImpl extends LocationServiceRepository {
  LocationServiceRepositoryImpl(this._api);

  final LocationServiceApi _api;

  @override
  Future<List<Province>> fetchProvinces() async {
    final provinceStr = await rootBundle.loadString(
      'assets/json/provinces.json',
    );
    final provinceJson = jsonDecode(provinceStr) as List;

    return provinceJson.map((e) => Province.fromJson(e)).toList();
  }

  @override
  Future<Map<String, List<Ward>>> initWardsByProvince() async {
    final Map<String, List<Ward>> _wardsByProvince = {};

    final wardStr = await rootBundle.loadString('assets/json/wards.json');

    final wardJson = jsonDecode(wardStr) as List;

    List<Ward> _wards = wardJson.map((e) => Ward.fromJson(e)).toList();

    for (final ward in _wards) {
      _wardsByProvince
          .putIfAbsent(ward.provinceCode.toString(), () => [])
          .add(ward);
    }

    return _wardsByProvince;
  }

  @override
  Future<Resource<List<SuggestedAddressResponse>>> searchAddress({
    required String provinceName,
    required String wardName,
    required int provinceCode,
    required int wardCode,
    String address = "",
  }) {
    return request(
      () => _api.searchAddress(
        province: provinceName,
        ward: wardName,
        provinceCode: provinceCode,
        wardCode: wardCode,
        displayType: 1,
        address: address,
      ),
    );
  }
}
