import 'package:freezed_annotation/freezed_annotation.dart';

part 'ward.freezed.dart';
part 'ward.g.dart';

@freezed
abstract class Ward with _$Ward {
  const factory Ward({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "code") required int code,
    @JsonKey(name: "division_type") String? divisionType,
    @JsonKey(name: "codename") String? codename,
    @JsonKey(name: "province_code") required int provinceCode,
  }) = _Ward;

  factory Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);
}
