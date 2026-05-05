import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';

@lazySingleton
class ApplyOrdersHistoryFiltersUseCase {
  List<OrderHistoryInfoEntity> call({
    required List<OrderHistoryInfoEntity> orders,
    int? provinceCode,
    int? wardCode,
    DateTime? createdDate,
    String phone = "",
    String orderCode = "",
    double minCodAmount = 0,
    double maxCodAmount = 1000000,
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
          !(order.orderNumber ?? "").toLowerCase().contains(
            orderCode.toLowerCase(),
          )) {
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

  bool _isSameDate(DateTime? source, DateTime? target) {
    if (source == null || target == null) return false;

    final local = source.toLocal();
    return local.year == target.year &&
        local.month == target.month &&
        local.day == target.day;
  }
}
