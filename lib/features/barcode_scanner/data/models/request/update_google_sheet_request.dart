import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_google_sheet_request.freezed.dart';
part 'update_google_sheet_request.g.dart';

@freezed
abstract class UpdateGoogleSheetRequest with _$UpdateGoogleSheetRequest {
  const factory UpdateGoogleSheetRequest({
    @JsonKey(name: "medicalRecordCode") required String medicalRecordCode,
    @JsonKey(name: "shopId") required String shopId,
  }) = _UpdateGoogleSheetRequest;

  factory UpdateGoogleSheetRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGoogleSheetRequestFromJson(json);
}
