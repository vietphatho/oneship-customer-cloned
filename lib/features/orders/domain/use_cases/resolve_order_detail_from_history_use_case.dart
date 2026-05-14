import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/orders_history_entity.dart';

class ResolveOrderDetailFromHistoryUseCase {
  const ResolveOrderDetailFromHistoryUseCase();

  OrderDetailEntity call(OrderHistoryInfoEntity order) {
    return OrderDetailEntity(
      id: order.id,
      orderNumber: order.orderNumber,
      trackingCode: order.orderNumber,
      status: order.status,
      codAmount: order.codAmount ?? 0,
      fullAddress: order.fullAddress ?? order.address,
      customerName: order.customerName,
      phone: order.phone,
      createdAt: order.createdAt,
      provinceCode: order.provinceCode,
      wardCode: order.wardCode,
    );
  }
}
