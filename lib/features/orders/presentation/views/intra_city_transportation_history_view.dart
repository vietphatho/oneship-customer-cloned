import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_order_transport_history_timeline_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_transport_history_timeline.dart';

class IntraCityTransportationHistoryView extends StatelessWidget {
  IntraCityTransportationHistoryView({
    super.key,
    required this.deliveryHistory,
    this.fallbackStartedAt,
  });

  final List<DeliveryHistoryEntity> deliveryHistory;
  final DateTime? fallbackStartedAt;
  final ResolveOrderTransportHistoryTimelineUseCase
  _resolveTransportHistoryTimelineUseCase =
      ResolveOrderTransportHistoryTimelineUseCase();

  @override
  Widget build(BuildContext context) {
    final history = deliveryHistory.firstOrNull;
    final items = _resolveTransportHistoryTimelineUseCase.call(
      history,
      fallbackStartedAt: fallbackStartedAt,
    );

    if (items.isEmpty) {
      return const PrimaryEmptyData();
    }

    return OrderTransportHistoryTimeline(items: items);
  }
}
