import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_history_filters.dart';

class OrdersHistoryController {
  final int _pageSize = 10;

  bool _showFilters = false;
  bool get showFilters => _showFilters;

  OrdersHistoryFilters _filters = OrdersHistoryFilters.empty();
  OrdersHistoryFilters get filters => _filters;

  List<OrderInfo> _deliveredOrders = [];
  List<OrderInfo> get deliveredOrders => _deliveredOrders;

  List<OrderInfo> _returnedOrders = [];
  List<OrderInfo> get returnedOrders => _returnedOrders;

  List<OrderInfo> get filteredDeliveredOrders =>
      _applyFilters(_deliveredOrders);

  List<OrderInfo> get filteredReturnedOrders => _applyFilters(_returnedOrders);

  List<OrderInfo> get visibleDeliveredOrders => _limit(filteredDeliveredOrders);

  List<OrderInfo> get visibleReturnedOrders => _limit(filteredReturnedOrders);

  double get maxCodAmount {
    final allOrders = [..._deliveredOrders, ..._returnedOrders];
    if (allOrders.isEmpty) return 1000000;

    final maxCod = allOrders
        .map((order) => (order.codAmount ?? 0).toDouble())
        .reduce((current, next) => current > next ? current : next);

    if (maxCod <= 0) return 1000000;
    if (maxCod < 1000000) return 1000000;
    return maxCod;
  }

  void setOrders(OrderStatus status, List<OrderInfo> orders) {
    switch (status) {
      case OrderStatus.delivered:
        _deliveredOrders = orders;
        break;
      case OrderStatus.returned:
        _returnedOrders = orders;
        break;
      default:
        break;
    }
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
  }

  void applyFilters(OrdersHistoryFilters filters) {
    _filters = filters;
    _showFilters = false;
  }

  void clearFilters() {
    _filters = OrdersHistoryFilters.empty();
    _showFilters = false;
  }

  List<OrderInfo> _limit(List<OrderInfo> orders) {
    if (orders.length <= _pageSize) return orders;
    return orders.take(_pageSize).toList();
  }

  List<OrderInfo> _applyFilters(List<OrderInfo> orders) {
    return orders.where((order) {
      if (_filters.province != null && order.city != _filters.province!.code) {
        return false;
      }

      if (_filters.ward != null && order.ward != _filters.ward!.code) {
        return false;
      }

      if (_filters.phone.isNotEmpty &&
          !(order.phone ?? "").toLowerCase().contains(
            _filters.phone.toLowerCase(),
          )) {
        return false;
      }

      if (_filters.orderCode.isNotEmpty &&
          !(order.orderNumber ?? "").toLowerCase().contains(
            _filters.orderCode.toLowerCase(),
          )) {
        return false;
      }

      if (_filters.createdDate != null &&
          !_isSameDate(order.createdAt, _filters.createdDate)) {
        return false;
      }

      final codAmount = (order.codAmount ?? 0).toDouble();
      if (codAmount < _filters.codRange.start ||
          codAmount > _filters.codRange.end) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _isSameDate(DateTime? source, DateTime? target) {
    if (source == null || target == null) return false;

    final local = source.toLocal();
    return local.year == target.year &&
        local.month == target.month &&
        local.day == target.day;
  }
}
