import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';

part 'vendor_orders_state.freezed.dart';

@freezed
abstract class VendorOrdersState with _$VendorOrdersState {
  const factory VendorOrdersState({
    required Resource<VendorOrdersEntity> processingOrdersResource,
    required Resource<VendorOrdersEntity> archivedOrdersResource,
    @Default([]) List<VendorOrderEntity> processingOrders,
    @Default([]) List<VendorOrderEntity> archivedOrders,
    @Default('') String processingKeyword,
    @Default('') String archivedKeyword,
    @Default(1) int processingPage,
    @Default(1) int archivedPage,
  }) = _VendorOrdersState;

  factory VendorOrdersState.initial() => VendorOrdersState(
    processingOrdersResource: Resource.loading(),
    archivedOrdersResource: Resource.loading(),
  );
}

extension VendorOrdersStateX on VendorOrdersState {
  bool get isProcessingLoading =>
      processingOrdersResource.state == Result.loading;

  bool get isArchivedLoading => archivedOrdersResource.state == Result.loading;
}
