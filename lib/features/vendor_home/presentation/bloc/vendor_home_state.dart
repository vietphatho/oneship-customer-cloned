import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/vendor_home/domain/entities/vendor_order_entity.dart';

part 'vendor_home_state.freezed.dart';

@freezed
abstract class VendorHomeState with _$VendorHomeState {
  const factory VendorHomeState({
    required Resource<VendorOrdersEntity> processingOrdersResource,
    required Resource<VendorOrdersEntity> archivedOrdersResource,
    @Default([]) List<VendorOrderEntity> processingOrders,
    @Default([]) List<VendorOrderEntity> archivedOrders,
    @Default('') String processingKeyword,
    @Default('') String archivedKeyword,
    @Default(1) int processingPage,
    @Default(1) int archivedPage,
  }) = _VendorHomeState;

  factory VendorHomeState.initial() => VendorHomeState(
    processingOrdersResource: Resource.loading(),
    archivedOrdersResource: Resource.loading(),
  );
}

extension VendorHomeStateX on VendorHomeState {
  bool get isProcessingLoading =>
      processingOrdersResource.state == Result.loading;

  bool get isArchivedLoading => archivedOrdersResource.state == Result.loading;
}
