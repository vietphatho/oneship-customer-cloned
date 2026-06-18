import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_scan_result.freezed.dart';
part 'barcode_scan_result.g.dart';

@freezed
abstract class BarcodeScanResult with _$BarcodeScanResult {
  const factory BarcodeScanResult({
    required String code,
    required String format,
  }) = _BarcodeScanResult;

  factory BarcodeScanResult.fromJson(Map<String, dynamic> json) =>
      _$BarcodeScanResultFromJson(json);
}
