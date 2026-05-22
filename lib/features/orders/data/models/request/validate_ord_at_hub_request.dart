import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_ord_at_hub_request.freezed.dart';
part 'validate_ord_at_hub_request.g.dart';

@freezed
abstract class ValidateOrdAtHubRequest with _$ValidateOrdAtHubRequest {
  const factory ValidateOrdAtHubRequest({
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "nextAction") String? nextAction,
  }) = _ValidateOrdAtHubRequest;

  factory ValidateOrdAtHubRequest.fromJson(Map<String, dynamic> json) =>
      _$ValidateOrdAtHubRequestFromJson(json);
}
