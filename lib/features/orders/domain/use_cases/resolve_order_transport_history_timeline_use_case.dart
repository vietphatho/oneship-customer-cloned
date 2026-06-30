import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_transport_history_timeline_entity.dart';

class ResolveOrderTransportHistoryTimelineUseCase {
  List<OrderTransportHistoryTimelineEntity> call(
    DeliveryHistoryEntity? history, {
    DateTime? fallbackStartedAt,
  }) {
    if (history == null) {
      return _buildFallbackStartedItem(fallbackStartedAt);
    }

    final items = <OrderTransportHistoryTimelineEntity?>[
      _buildItem(
        title: 'delivery_successfully',
        description: 'delivered_desc',
        time: history.deliveredAt,
        images: history.confirmationImages ?? [],
        showCompletedTag: true,
      ),
      _buildItem(
        title: 'shipping',
        description: 'arrived_at_delivery_desc',
        time: history.arrivedAtDelivery,
      ),
      _buildItem(
        title: 'picked_up',
        description: 'at_shop',
        time: history.pickupConfirmedAt,
        images: history.pickupImages ?? [],
      ),
      _buildItem(
        title: 'start_processing',
        description: 'at_shop',
        time:
            history.scannedAt ?? history.addedToPackageAt ?? fallbackStartedAt,
      ),
    ];

    final resolvedItems = items
        .whereType<OrderTransportHistoryTimelineEntity>()
        .toList();
    if (resolvedItems.isNotEmpty) return resolvedItems;

    return _buildFallbackStartedItem(fallbackStartedAt);
  }

  OrderTransportHistoryTimelineEntity? _buildItem({
    required String title,
    required String description,
    required DateTime? time,
    List<String> images = const [],
    bool showCompletedTag = false,
  }) {
    if (time == null) return null;

    return OrderTransportHistoryTimelineEntity(
      title: title,
      description: description,
      time: time,
      images: images,
      showCompletedTag: showCompletedTag,
    );
  }

  List<OrderTransportHistoryTimelineEntity> _buildFallbackStartedItem(
    DateTime? fallbackStartedAt,
  ) {
    if (fallbackStartedAt == null) return [];

    return [
      OrderTransportHistoryTimelineEntity(
        title: 'start_processing',
        description: 'at_shop',
        time: fallbackStartedAt,
      ),
    ];
  }
}
