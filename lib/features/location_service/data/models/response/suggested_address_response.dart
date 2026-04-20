import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggested_address_response.freezed.dart';
part 'suggested_address_response.g.dart';

@freezed
abstract class SuggestedAddressResponse with _$SuggestedAddressResponse {
  const factory SuggestedAddressResponse({
    @JsonKey(name: "ref_id") String? refId,
    @JsonKey(name: "display") String? display,
  }) = _SuggestedAddressResponse;

  factory SuggestedAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestedAddressResponseFromJson(json);
}
