import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/orders/presentation/views/order_transportation_history_view.dart';

class OrderTrackingDetailSession extends StatelessWidget {
  const OrderTrackingDetailSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc orderTrackingBloc = getIt.get();

    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: orderTrackingBloc,
      builder: (context, state) {
        final trackingResult = state.trackingResult.data;
        if (trackingResult == null) {
          return const PrimaryEmptyData();
        }

        return OrderTransportationHistoryView(trackingResult: trackingResult);
      },
    );
  }
}
