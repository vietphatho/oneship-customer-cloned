import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_info_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_detail_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_input_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_shipper_info.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "order_tracking".tr()),
      body: Column(
        children: [
          const OrderTrackingInputSession(),
          AppSpacing.horizontal(AppDimensions.mediumSpacing),
          Expanded(
            child: SingleChildScrollView(child: const _OrderTrackingSession()),
          ),
        ],
      ),
    );
  }
}

class _OrderTrackingSession extends StatelessWidget {
  const _OrderTrackingSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc _orderTrackingBloc = getIt.get();

    return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      buildWhen:
          (previous, current) =>
              previous.trackingResult.state != current.trackingResult.state,
      builder: (context, state) {
        if (state.trackingResult.state != Result.success) {
          return const PrimaryEmptyData();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderInfoSession(),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              OrderTrackingShipperInfoSession(),
              AppSpacing.vertical(AppDimensions.xLargeSpacing),
              PrimaryText(
                "shipment_timeline".tr(),
                style: AppTextStyles.labelLarge,
              ),
              AppSpacing.vertical(AppDimensions.xLargeSpacing),
              OrderTrackingDetailSession(),
            ],
          ),
        );
      },
    );
  }
}
