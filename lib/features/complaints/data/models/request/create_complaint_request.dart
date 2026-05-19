import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_complaint_request.freezed.dart';
part 'create_complaint_request.g.dart';

@freezed
abstract class CreateComplaintRequest with _$CreateComplaintRequest {
  const factory CreateComplaintRequest({
    @JsonKey(name: "category") required String category,
    @JsonKey(name: "priority") required String priority,
    @JsonKey(name: "subject") required String subject,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "referenceType") required String referenceType,
    @JsonKey(name: "referenceId") required String referenceId,
    @JsonKey(name: "shopId") String? shopId,
  }) = _CreateComplaintRequest;

  factory CreateComplaintRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateComplaintRequestFromJson(json);
}
