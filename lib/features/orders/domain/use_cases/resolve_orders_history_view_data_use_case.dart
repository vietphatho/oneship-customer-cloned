import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';

class OrdersHistoryViewData {
  const OrdersHistoryViewData({
    required this.filteredDeliveredOrders,
    required this.filteredReturnedOrders,
    required this.visibleDeliveredOrders,
    required this.visibleReturnedOrders,
    required this.maxCodAmount,
  });

  final List<OrderHistoryInfoEntity> filteredDeliveredOrders;
  final List<OrderHistoryInfoEntity> filteredReturnedOrders;
  final List<OrderHistoryInfoEntity> visibleDeliveredOrders;
  final List<OrderHistoryInfoEntity> visibleReturnedOrders;
  final double maxCodAmount;
}

@lazySingleton
class ResolveOrdersHistoryViewDataUseCase {
  static const int _pageSize = 10;
  static const double _defaultMaxCodAmount = 1000000;

  OrdersHistoryViewData call({
    required List<OrderHistoryInfoEntity> deliveredOrders,
    required List<OrderHistoryInfoEntity> returnedOrders,
    int? provinceCode,
    int? wardCode,
    DateTime? createdDate,
    String phone = "",
    String orderCode = "",
    double minCodAmount = 0,
    double maxCodFilterAmount = _defaultMaxCodAmount,
  }) {
    final filteredDeliveredOrders = _applyFilters(
      orders: deliveredOrders,
      provinceCode: provinceCode,
      wardCode: wardCode,
      createdDate: createdDate,
      phone: phone,
      orderCode: orderCode,
      minCodAmount: minCodAmount,
      maxCodAmount: maxCodFilterAmount,
    );
    final filteredReturnedOrders = _applyFilters(
      orders: returnedOrders,
      provinceCode: provinceCode,
      wardCode: wardCode,
      createdDate: createdDate,
      phone: phone,
      orderCode: orderCode,
      minCodAmount: minCodAmount,
      maxCodAmount: maxCodFilterAmount,
    );

    return OrdersHistoryViewData(
      filteredDeliveredOrders: filteredDeliveredOrders,
      filteredReturnedOrders: filteredReturnedOrders,
      visibleDeliveredOrders: _limit(filteredDeliveredOrders),
      visibleReturnedOrders: _limit(filteredReturnedOrders),
      maxCodAmount: _maxCodAmount([...deliveredOrders, ...returnedOrders]),
    );
  }

  List<OrderHistoryInfoEntity> _applyFilters({
    required List<OrderHistoryInfoEntity> orders,
    int? provinceCode,
    int? wardCode,
    DateTime? createdDate,
    String phone = "",
    String orderCode = "",
    double minCodAmount = 0,
    double maxCodAmount = _defaultMaxCodAmount,
  }) {
    return orders.where((order) {
      final orderProvinceCode = order.city ?? order.provinceCode;
      if (provinceCode != null && orderProvinceCode != provinceCode) {
        return false;
      }

      final orderWardCode = order.ward ?? order.wardCode;
      if (wardCode != null && orderWardCode != wardCode) {
        return false;
      }

      if (phone.isNotEmpty &&
          !(order.phone ?? "").toLowerCase().contains(phone.toLowerCase())) {
        return false;
      }

      if (orderCode.isNotEmpty &&
          !(order.orderNumber ?? "")
              .toLowerCase()
              .contains(orderCode.toLowerCase())) {
        return false;
      }

      if (createdDate != null && !_isSameDate(order.createdAt, createdDate)) {
        return false;
      }

      final codAmount = (order.codAmount ?? 0).toDouble();
      if (codAmount < minCodAmount || codAmount > maxCodAmount) {
        return false;
      }

      return true;
    }).toList();
  }

  List<OrderHistoryInfoEntity> _limit(List<OrderHistoryInfoEntity> orders) {
    if (orders.length <= _pageSize) return orders;
    return orders.take(_pageSize).toList();
  }

  double _maxCodAmount(List<OrderHistoryInfoEntity> orders) {
    if (orders.isEmpty) return _defaultMaxCodAmount;

    final maxCod = orders
        .map((order) => (order.codAmount ?? 0).toDouble())
        .reduce((current, next) => current > next ? current : next);

    if (maxCod <= 0) return _defaultMaxCodAmount;
    if (maxCod < _defaultMaxCodAmount) return _defaultMaxCodAmount;
    return maxCod;
  }

  bool _isSameDate(DateTime? source, DateTime? target) {
    if (source == null || target == null) return false;

    final local = source.toLocal();
    return local.year == target.year &&
        local.month == target.month &&
        local.day == target.day;
  }
}
