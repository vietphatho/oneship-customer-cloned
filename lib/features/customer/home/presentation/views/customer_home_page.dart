import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_app_bar.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_drawer.dart';
import 'package:oneship_customer/features/customer/home/presentation/widgets/customer_order_tracking_input_session.dart';
import 'package:oneship_customer/features/location_service/bloc/location_service_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/map_view.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_detail_session.dart';
import 'package:oneship_customer/features/order_tracking/presentation/widget/order_tracking_shipper_info.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final OrderTrackingBloc _orderTrackingBloc = getIt.get();
  final LocationServiceBloc _locationServiceBloc = getIt.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: AppColors.shopHomeGradBg),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomerAppBar(),
          drawer: const CustomerDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                const CustomerOrderTrackingInputSession(),
                // CustomerOrdTabBar(tabController: _tabCtrl),
                // Expanded(child: TabBarView(children: )),
                Expanded(
                  child: BlocConsumer<OrderTrackingBloc, OrderTrackingState>(
                    bloc: _orderTrackingBloc,
                    listener: _handleOrderTrackingListener,
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: AppDimensions.mediumPaddingAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OrderTrackingShipperInfoSession(),
                            if (_orderTrackingBloc.state.trackingResult.data !=
                                null) ...[
                              AppSpacing.vertical(AppDimensions.xLargeSpacing),
                              MapView(),
                            ],
                            AppSpacing.vertical(AppDimensions.xLargeSpacing),
                            OrderTrackingDetailSession(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleOrderTrackingListener(
    BuildContext context,
    OrderTrackingState state,
  ) {
    switch (state.trackingResult.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        _locationServiceBloc.getCurrentLocation();
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.trackingResult.message,
        );
        break;
    }
  }
}
