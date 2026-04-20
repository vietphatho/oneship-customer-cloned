import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_dispatch_request.freezed.dart';
part 'package_dispatch_request.g.dart';

@freezed
abstract class PackageDispatchRequest with _$PackageDispatchRequest {
  const factory PackageDispatchRequest({
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "data") PackageDispatchDataRequest? data,
  }) = _PackageDispatchRequest;

  factory PackageDispatchRequest.create({
    required String shopId,
    required String type,
  }) => PackageDispatchRequest(
    type: type,
    data: PackageDispatchDataRequest(shopId: shopId),
  );

  factory PackageDispatchRequest.fromJson(Map<String, dynamic> json) =>
      _$PackageDispatchRequestFromJson(json);
}

@freezed
abstract class PackageDispatchDataRequest with _$PackageDispatchDataRequest {
  const factory PackageDispatchDataRequest({
    @JsonKey(name: "shopId") String? shopId,
  }) = _PackageDispatchDataRequest;

  factory PackageDispatchDataRequest.fromJson(Map<String, dynamic> json) =>
      _$PackageDispatchDataRequestFromJson(json);
}
