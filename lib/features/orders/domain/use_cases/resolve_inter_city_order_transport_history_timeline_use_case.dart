import 'package:collection/collection.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_transport_history_timeline_entity.dart';

class ResolveInterCityOrderTransportHistoryTimelineUseCase {
  List<OrderTransportHistoryTimelineEntity> call(
    List<DeliveryHistoryEntity> histories,
  ) {
    return histories
        .map(
          (history) => OrderTransportHistoryTimelineEntity(
            title: _resolveStatusLabel(history),
            description: '',
            time: history.scannedAt,
          ),
        )
        .toList();
  }

  String _resolveStatusLabel(DeliveryHistoryEntity history) {
    final rawStatus = history.rawStatus?.trim();
    if (rawStatus != null && rawStatus.isNotEmpty) {
      final mappedStatus = OrderStatus.values.firstWhereOrNull(
        (status) => status.value == rawStatus,
      );
      return mappedStatus?.value ?? rawStatus;
    }

    return history.status.value;
  }
}
