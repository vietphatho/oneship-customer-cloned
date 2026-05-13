import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shop_staff_request.freezed.dart';
part 'add_shop_staff_request.g.dart';

@freezed
abstract class AddShopStaffRequest with _$AddShopStaffRequest {
  const factory AddShopStaffRequest({
    @JsonKey(name: "userId") required String userId,
    @JsonKey(name: "permissions")
    required Map<String, Map<String, bool>> permissions,
  }) = _AddShopStaffRequest;

  factory AddShopStaffRequest.fromJson(Map<String, dynamic> json) =>
      _$AddShopStaffRequestFromJson(json);
}
