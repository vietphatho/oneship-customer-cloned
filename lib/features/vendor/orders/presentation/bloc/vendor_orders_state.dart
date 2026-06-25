import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/vendor/orders/domain/entities/vendor_order_entity.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';

part 'vendor_orders_state.freezed.dart';

@freezed
abstract class VendorOrdersState with _$VendorOrdersState {
  const factory VendorOrdersState({
    required Resource<VendorOrdersEntity> processingOrdersResource,
    required Resource<VendorOrdersEntity> archivedOrdersResource,
    required Resource<OrderDetailEntity> orderDetailResource,
    @Default([]) List<VendorOrderEntity> processingOrders,
    @Default([]) List<VendorOrderEntity> archivedOrders,
    @Default('') String processingKeyword,
    @Default('') String archivedKeyword,
    @Default(1) int processingPage,
    @Default(1) int archivedPage,
    String? selectedOrderId,
    VendorOrdersTab? selectedOrderTab,
  }) = _VendorOrdersState;

  factory VendorOrdersState.initial() => VendorOrdersState(
    processingOrdersResource: Resource.loading(),
    archivedOrdersResource: Resource.loading(),
    orderDetailResource: Resource.loading(),
  );
}

extension VendorOrdersStateX on VendorOrdersState {
  bool get isProcessingLoading =>
      processingOrdersResource.state == Result.loading;

  bool get isArchivedLoading => archivedOrdersResource.state == Result.loading;

  bool get isOrderDetailLoading =>
      orderDetailResource.state == Result.loading && selectedOrderId != null;

  bool get hasMoreProcessingOrders => _hasMore(processingOrdersResource.data);

  bool get hasMoreArchivedOrders => _hasMore(archivedOrdersResource.data);

  bool hasMoreOrders(VendorOrdersTab tab) {
    return switch (tab) {
      VendorOrdersTab.processing => hasMoreProcessingOrders,
      VendorOrdersTab.archived => hasMoreArchivedOrders,
    };
  }

  Resource<VendorOrdersEntity> ordersResource(VendorOrdersTab tab) {
    return switch (tab) {
      VendorOrdersTab.processing => processingOrdersResource,
      VendorOrdersTab.archived => archivedOrdersResource,
    };
  }

  List<VendorOrderEntity> orders(VendorOrdersTab tab) {
    return switch (tab) {
      VendorOrdersTab.processing => processingOrders,
      VendorOrdersTab.archived => archivedOrders,
    };
  }

  static bool _hasMore(VendorOrdersEntity? data) {
    final meta = data?.meta;
    if (meta == null) return false;
    if (meta.hasNext != null) return meta.hasNext!;

    final page = meta.page ?? 1;
    final limit = meta.limit ?? 0;
    final total = meta.total;
    final totalPages = meta.totalPages;

    if (totalPages != null) return page < totalPages;
    if (total != null && limit > 0) return page * limit < total;
    return false;
  }
}
