import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_response_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/processing_orders_filter_panel.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/core/utils/utils.dart';

part 'orders_state.freezed.dart';

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    required Resource<OrdersListResponse> orderListByStatusResource,
    required Resource<OrdersHistoryResponseEntity> ordersHistoryResource,
    required Resource<OrderDetailEntity> orderDetailResource,
    required Resource deleteOrderResource,
    required Resource validateOrdAtHubResource,
    @Default([]) List<OrderInfo> allProcessingOrdersList,
    @Default([]) List<OrderInfo> atHubOrdersList,
    @Default([]) List<OrderInfo> pendingOrdersList,
    @Default([]) List<OrderInfo> processingOrdersList,
    @Default([]) List<OrderInfo> batchedOrdersList,
    @Default([]) List<OrderInfo> deliveringOrdersList,
    @Default([]) List<OrderInfo> delayedOrdersList,
    @Default([]) List<OrderInfo> cancelledOrdersList,
    @Default([]) List<OrderInfo> returnedOrdersList,
    @Default([]) List<OrdersHistoryEntity> deliveredOrdersHistoryList,
    @Default([]) List<OrdersHistoryEntity> returnedOrdersHistoryList,
    @Default([]) List<OrdersHistoryEntity> allOrdersHistoryList,
    @Default(1000000) double ordersHistoryMaxCodAmount,
    @Default(false) bool showOrdersHistoryFilters,
    @Default(OrdersHistoryFilters()) OrdersHistoryFilters ordersHistoryFilters,
    @Default(ProcessingOrdersFilters())
    ProcessingOrdersFilters processingOrdersFilters,
    @Default({})
    Map<String, Resource<List<SurchargeGroupEntity>>>
    visibleSurchargeGroupsByShopId,
  }) = _OrdersState;
}

extension OrdersStateX on OrdersState {
  bool get hasData => orderListByStatusResource.data?.meta?.hasNext == true;

  Resource<List<SurchargeGroupEntity>> visibleSurchargeGroupsResource(
    String? shopId,
  ) {
    if (shopId == null || shopId.isEmpty) {
      return Resource.loading(data: const <SurchargeGroupEntity>[]);
    }
    return visibleSurchargeGroupsByShopId[shopId] ??
        Resource.loading(data: const <SurchargeGroupEntity>[]);
  }

  List<SurchargeGroupEntity> visibleSurchargeGroups(String? shopId) {
    return visibleSurchargeGroupsResource(shopId).data ??
        const <SurchargeGroupEntity>[];
  }

  List<OrderFeeDisplayEntity> resolveOrderFeeDisplays({
    required String? shopId,
    required List<OrderFeeEntity> fees,
  }) {
    final groups = visibleSurchargeGroups(shopId);
    return fees.map((fee) => fee.toDisplayEntity(groups)).toList();
  }

  List<OrderInfo> get filteredAllProcessingOrdersList =>
      _applyFilter(allProcessingOrdersList);
  List<OrderInfo> get filteredAtHubOrdersList => _applyFilter(atHubOrdersList);
  List<OrderInfo> get filteredPendingOrdersList =>
      _applyFilter(pendingOrdersList);
  List<OrderInfo> get filteredProcessingOrdersList =>
      _applyFilter(processingOrdersList);
  List<OrderInfo> get filteredBatchedOrdersList =>
      _applyFilter(batchedOrdersList);
  List<OrderInfo> get filteredDeliveringOrdersList =>
      _applyFilter(deliveringOrdersList);
  List<OrderInfo> get filteredDelayedOrdersList =>
      _applyFilter(delayedOrdersList);
  List<OrderInfo> get filteredCancelledOrdersList =>
      _applyFilter(cancelledOrdersList);
  List<OrderInfo> get filteredReturnedOrdersList =>
      _applyFilter(returnedOrdersList);

  List<OrderInfo> _applyFilter(List<OrderInfo> list) {
    if (processingOrdersFilters.isEmpty) return list;
    return list.where((order) {
      final filters = processingOrdersFilters;
      if (filters.orderCode.isNotEmpty) {
        if (!(order.orderNumber?.toLowerCase().contains(
              filters.orderCode.toLowerCase(),
            ) ??
            false)) {
          return false;
        }
      }
      if (filters.phone.isNotEmpty) {
        final formattedOrderPhone = Utils.formatPhoneNumber(order.phone);
        if (!formattedOrderPhone.contains(filters.phone)) {
          return false;
        }
      }
      if (filters.province != null) {
        if (order.provinceCode != filters.province!.code) {
          return false;
        }
      }
      if (filters.ward != null) {
        if (order.wardCode != filters.ward!.code) {
          return false;
        }
      }
      if (filters.fromDate != null || filters.toDate != null) {
        final date = order.createdAt;
        if (date == null) return false;
        final checkDate = DateTime(date.year, date.month, date.day);

        if (filters.fromDate != null) {
          final from = DateTime(
            filters.fromDate!.year,
            filters.fromDate!.month,
            filters.fromDate!.day,
          );
          if (checkDate.isBefore(from)) return false;
        }
        if (filters.toDate != null) {
          final to = DateTime(
            filters.toDate!.year,
            filters.toDate!.month,
            filters.toDate!.day,
          );
          if (checkDate.isAfter(to)) return false;
        }
      }
      return true;
    }).toList();
  }

  List<OrdersHistoryEntity> get filteredAllOrdersHistoryList => _applyHistoryFilter(allOrdersHistoryList);
  List<OrdersHistoryEntity> get filteredDeliveredOrdersHistoryList => _applyHistoryFilter(deliveredOrdersHistoryList);
  List<OrdersHistoryEntity> get filteredReturnedOrdersHistoryList => _applyHistoryFilter(returnedOrdersHistoryList);

  List<OrdersHistoryEntity> _applyHistoryFilter(List<OrdersHistoryEntity> list) {
    if (processingOrdersFilters.isEmpty) return list;
    return list.where((order) {
      final filters = processingOrdersFilters;
      if (filters.orderCode.isNotEmpty) {
        if (!(order.orderNumber?.toLowerCase().contains(filters.orderCode.toLowerCase()) ?? false)) {
          return false;
        }
      }
      if (filters.phone.isNotEmpty) {
        final formattedOrderPhone = Utils.formatPhoneNumber(order.phone);
        if (!formattedOrderPhone.contains(filters.phone)) {
          return false;
        }
      }
      if (filters.province != null) {
        if (order.provinceCode != filters.province!.code) {
          return false;
        }
      }
      if (filters.ward != null) {
        if (order.wardCode != filters.ward!.code) {
          return false;
        }
      }
      if (filters.fromDate != null || filters.toDate != null) {
        final date = order.createdAt;
        if (date == null) return false;
        final checkDate = DateTime(date.year, date.month, date.day);
        
        if (filters.fromDate != null) {
          final from = DateTime(filters.fromDate!.year, filters.fromDate!.month, filters.fromDate!.day);
          if (checkDate.isBefore(from)) return false;
        }
        if (filters.toDate != null) {
          final to = DateTime(filters.toDate!.year, filters.toDate!.month, filters.toDate!.day);
          if (checkDate.isAfter(to)) return false;
        }
      }
      return true;
    }).toList();
  }

  int getHistoryOrdersCountForStatus(OrderStatus status) {
    if (status == OrderStatus.allProcessing) return filteredAllOrdersHistoryList.length;
    if (status == OrderStatus.delivered) return filteredDeliveredOrdersHistoryList.length;
    if (status == OrderStatus.returned) return filteredReturnedOrdersHistoryList.length;
    return 0;
  }
}
