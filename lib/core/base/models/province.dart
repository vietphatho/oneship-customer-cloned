import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/ward.dart';

part 'province.freezed.dart';
part 'province.g.dart';

@freezed
abstract class Province with _$Province {
  const factory Province({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "code") required int code,
    @JsonKey(name: "division_type") String? divisionType,
    @JsonKey(name: "codename") String? codename,
    @JsonKey(name: "phone_code") int? phoneCode,
    @JsonKey(name: "wards") List<Ward>? wards,
  }) = _Province;

  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
}
