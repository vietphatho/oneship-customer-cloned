import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_detail_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_input_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_shipper_info.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  @override
  void dispose() {
    _orderTrackingBloc.resetData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: AppDimensions.getSize(context).width,
          height: AppDimensions.getSize(context).height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFFB16F), Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                ),
              ),
              const OrderTrackingInputSession(),
              AppSpacing.horizontal(AppDimensions.mediumSpacing),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: const _OrderTrackingSession(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderTrackingSession extends StatelessWidget {
  const _OrderTrackingSession({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderTrackingBloc _orderTrackingBloc = getIt.get();

    return BlocConsumer<OrderTrackingBloc, OrderTrackingState>(
      bloc: _orderTrackingBloc,
      listener: _handleOrderTrackingListener,
      builder: (context, state) {
        var trackingResult = state.trackingResult;
        var orderNumber = trackingResult?.data?.orderNumber;

        if (trackingResult?.state != Result.success && (orderNumber?.isEmpty ?? true)) {
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
              OrderTrackingShipperInfoSession(),
              AppSpacing.vertical(AppDimensions.xLargeSpacing),
              OrderTrackingDetailSession(),
            ],
          ),
        );
      },
    );
  }

  void _handleOrderTrackingListener(
    BuildContext context,
    OrderTrackingState state,
  ) {
    switch (state.trackingResult!.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(context);
        break;
    }
  }
}
