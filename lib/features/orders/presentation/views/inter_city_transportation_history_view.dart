import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_inter_city_order_transport_history_timeline_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_transport_history_timeline.dart';

class InterCityTransportationHistoryView extends StatelessWidget {
  InterCityTransportationHistoryView({
    super.key,
    required this.deliveryHistory,
  });

  final List<DeliveryHistoryEntity> deliveryHistory;
  final ResolveInterCityOrderTransportHistoryTimelineUseCase
  _resolveTransportHistoryTimelineUseCase =
      ResolveInterCityOrderTransportHistoryTimelineUseCase();

  @override
  Widget build(BuildContext context) {
    final items = _resolveTransportHistoryTimelineUseCase.call(deliveryHistory);

    if (items.isEmpty) {
      return const PrimaryEmptyData();
    }

    return OrderTransportHistoryTimeline(items: items);
  }
}
