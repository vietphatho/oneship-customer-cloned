import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/base_meta_response.dart';
import 'package:oneship_customer/features/complaints/data/models/complaint_model.dart';

part 'complaint_list_response.freezed.dart';
part 'complaint_list_response.g.dart';

@freezed
abstract class ComplaintListResponse with _$ComplaintListResponse {
  const factory ComplaintListResponse({
    @JsonKey(name: "data") List<ComplaintModel>? data,
    @JsonKey(name: "items") List<ComplaintModel>? items,
    @JsonKey(name: "meta") BaseMetaResponse? meta,
  }) = _ComplaintListResponse;

  factory ComplaintListResponse.fromJson(Map<String, dynamic> json) =>
      _$ComplaintListResponseFromJson(json);
}
