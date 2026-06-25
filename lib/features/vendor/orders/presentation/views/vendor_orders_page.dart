import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_state.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/widgets/vendor_orders_section.dart';

class VendorOrdersPage extends StatefulWidget {
  const VendorOrdersPage({super.key});

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage> {
  static const _backgroundColor = AppColors.shopHomeV2Background;

  final VendorOrdersBloc _vendorOrdersBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _vendorOrdersBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: PrimaryAppBar(title: "orders".tr()),
      body: BlocListener<VendorOrdersBloc, VendorOrdersState>(
        bloc: _vendorOrdersBloc,
        listenWhen: (previous, current) =>
            previous.orderDetailResource != current.orderDetailResource ||
            previous.selectedOrderId != current.selectedOrderId,
        listener: _handleOrderDetailState,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.mediumSpacing,
              AppDimensions.mediumSpacing,
              AppDimensions.mediumSpacing,
              0,
            ),
            child: const VendorOrdersSection(),
          ),
        ),
      ),
    );
  }

  void _handleOrderDetailState(BuildContext context, VendorOrdersState state) {
    if (state.selectedOrderId == null) return;

    if (state.isOrderDetailLoading) {
      PrimaryDialog.showLoadingDialog(context);
      return;
    }

    PrimaryDialog.hideLoadingDialog(context);

    if (state.orderDetailResource.state == Result.success) {
      final orderDetail = state.orderDetailResource.data;
      if (orderDetail == null) return;

      getIt.get<OrdersBloc>().setOrderDetail(orderDetail);
      context.push(RouteName.vendorOrderDetailPage);
      return;
    }

    if (state.orderDetailResource.state == Result.error) {
      PrimaryDialog.showQuestionDialog(
        context,
        title: 'error',
        message: state.orderDetailResource.message.tr(),
        positiveButtonText: 'retry',
        negativeButtonText: 'close',
        onPositiveTapped: _vendorOrdersBloc.retryOrderDetail,
      );
    }
  }
}
