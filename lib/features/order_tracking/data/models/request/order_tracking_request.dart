import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_tracking_request.freezed.dart';
part 'order_tracking_request.g.dart';

@freezed
abstract class OrderTrackingRequest with _$OrderTrackingRequest {
  const factory OrderTrackingRequest({String? search}) = _OrderTrackingRequest;

  factory OrderTrackingRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingRequestFromJson(json);
}
