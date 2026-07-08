import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/orders/presentation/views/inter_city_transportation_history_view.dart';
import 'package:oneship_customer/features/orders/presentation/views/intra_city_transportation_history_view.dart';

class OrderTransportationHistoryView extends StatelessWidget {
  const OrderTransportationHistoryView({
    super.key,
    required this.trackingResult,
    this.fallbackStartedAt,
  });

  final OrderTrackingEntity trackingResult;
  final DateTime? fallbackStartedAt;

  @override
  Widget build(BuildContext context) {
    if (trackingResult.isIntraCity) {
      return IntraCityTransportationHistoryView(
        deliveryHistory: trackingResult.deliveryHistory,
        fallbackStartedAt: fallbackStartedAt,
      );
    }

    return InterCityTransportationHistoryView(
      deliveryHistory: trackingResult.deliveryHistory,
    );
  }
}
