import 'package:freezed_annotation/freezed_annotation.dart';

part 'process_hospital_scanner_request.freezed.dart';
part 'process_hospital_scanner_request.g.dart';

@freezed
abstract class ProcessHospitalScannerRequest
    with _$ProcessHospitalScannerRequest {
  const factory ProcessHospitalScannerRequest({
    @JsonKey(name: "medicalRecordCode") required String medicalRecordCode,
    @JsonKey(name: "shopId") required String shopId,
    @JsonKey(name: "scanSource") required String scanSource,
    @JsonKey(name: "scanAction") required String scanAction,
  }) = _ProcessHospitalScannerRequest;

  factory ProcessHospitalScannerRequest.fromJson(Map<String, dynamic> json) =>
      _$ProcessHospitalScannerRequestFromJson(json);
}
