import 'package:oneship_shop/core/base/base_repository.dart';
import 'package:oneship_shop/core/base/models/province.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/core/base/models/ward.dart';
import 'package:oneship_shop/features/location_service/data/models/response/suggested_address_response.dart';

abstract class LocationServiceRepository extends BaseRepository {
  Future<List<Province>> fetchProvinces();

  Future<Map<String, List<Ward>>> initWardsByProvince();

  Future<Resource<List<SuggestedAddressResponse>>> searchAddress({
    required String provinceName,
    required String wardName,
    required int provinceCode,
    required int wardCode,
    String address = "",
  });
}
