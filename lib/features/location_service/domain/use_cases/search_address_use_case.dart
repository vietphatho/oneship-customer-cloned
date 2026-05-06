import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/location_service/data/models/response/suggested_address_response.dart';
import 'package:oneship_customer/features/location_service/data/repositories/location_service_repository.dart';

@lazySingleton
class SearchAddressUseCase {
  final LocationServiceRepository _repository;

  SearchAddressUseCase(this._repository);

  Future<Resource<List<SuggestedAddressResponse>>> call({
    required String provinceName,
    required int provinceCode,
    required String wardName,
    required int wardCode,
    required String keyword,
  }) {
    return _repository.searchAddress(
      provinceName: provinceName,
      wardName: wardName,
      provinceCode: provinceCode,
      wardCode: wardCode,
      address: keyword,
    );
  }
}
