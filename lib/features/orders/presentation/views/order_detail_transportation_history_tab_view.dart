import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_event.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_order_transport_history_timeline_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_transport_history_timeline.dart';

class OrderDetailTransportationHistoryTabView extends StatefulWidget {
  const OrderDetailTransportationHistoryTabView({
    super.key,
    this.trackingCode,
    this.fallbackStartedAt,
  });

  final String? trackingCode;
  final DateTime? fallbackStartedAt;

  @override
  State<OrderDetailTransportationHistoryTabView> createState() =>
      _OrderDetailTransportationHistoryTabViewState();
}

class _OrderDetailTransportationHistoryTabViewState
    extends State<OrderDetailTransportationHistoryTabView> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  final ResolveOrderTransportHistoryTimelineUseCase
      _resolveTransportHistoryTimelineUseCase =
      ResolveOrderTransportHistoryTimelineUseCase();

  @override
  void initState() {
    super.initState();
    final trackingCode = widget.trackingCode;
    if (trackingCode?.isNotEmpty ?? false) {
      _orderTrackingBloc.add(OrderTrackingSearchEvent(trackingCode!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildResult(state.trackingResult)],
          ),
        );
      },
    );
  }

  Widget _buildResult(Resource<OrderTrackingEntity> result) {
    if (result.state == Result.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (result.state == Result.error || (result.data?.isEmpty ?? true)) {
      return const PrimaryEmptyData();
    }

    return _buildTimeline(result.data);
  }

  Widget _buildTimeline(OrderTrackingEntity? data) {
    final history = data?.deliveryHistory.firstOrNull;
    final items = _resolveTransportHistoryTimelineUseCase.call(
      history,
      fallbackStartedAt: widget.fallbackStartedAt,
    );

    if (items.isEmpty) {
      return const PrimaryEmptyData();
    }

    return OrderTransportHistoryTimeline(items: items);
  }
}
