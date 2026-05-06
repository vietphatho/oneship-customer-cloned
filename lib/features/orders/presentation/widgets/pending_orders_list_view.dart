import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';

class PendingOrdersListView extends StatefulWidget {
  const PendingOrdersListView({super.key});

  @override
  State<PendingOrdersListView> createState() => _PendingOrdersListViewState();
}

class _PendingOrdersListViewState extends State<PendingOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
  final PackagesBloc _pkgsBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    _ordersBloc.fetchOrdersByStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen:
              (previous, current) =>
                  previous.orderDetailResource != current.orderDetailResource,
          listener: _listenLoadDetailOrder,
        ),
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen:
              (previous, current) =>
                  previous.deleteOrderResource != current.deleteOrderResource,
          listener: _listenDeleteOrderState,
        ),
      ],
      child: Column(
        children: [
          const _TopActionButtons(),
          Expanded(
            child: BlocBuilder<OrdersBloc, OrdersState>(
              bloc: _ordersBloc,
              buildWhen:
                  (pre, cur) => pre.pendingOrdersList != cur.pendingOrdersList,
              builder: (context, state) {
                List<OrderInfo> _orders = state.pendingOrdersList;

                if (_orders.isEmpty) {
                  return SafeArea(top: false, child: const PrimaryEmptyData());
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.smallSpacing,
                    horizontal: AppDimensions.smallSpacing,
                  ),
                  itemCount: _orders.length,
                  itemBuilder:
                      (context, index) => OrderInfoItem(
                        index: index + 1,
                        order: _orders[index],
                        onTap: onTap,
                        onRemoved: _onRemoved,
                      ),
                  separatorBuilder:
                      (context, index) =>
                          AppSpacing.vertical(AppDimensions.xSmallSpacing),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onTap(OrderInfo order) {
    _ordersBloc.fetchOrderDetail(shopId: order.shopId!, orderId: order.id!);
  }

  void _onRemoved(OrderInfo order) {
    _ordersBloc.deleteOrder(order);
  }

  void _listenLoadDetailOrder(BuildContext context, OrdersState state) {
    switch (state.orderDetailResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.orderDetailPage);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.orderDetailResource.message,
        );
    }
  }

  void _listenDeleteOrderState(BuildContext context, OrdersState state) {
    switch (state.deleteOrderResource.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);

        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.deleteOrderResource.message,
        );
    }
  }
}

class _TopActionButtons extends StatelessWidget {
  const _TopActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final PackagesBloc _pkgsBloc = getIt.get();
    final OrdersBloc _ordersBloc = getIt.get();

    return BlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      buildWhen: (pre, cur) => pre.pendingOrdersList != cur.pendingOrdersList,
      builder: (context, state) {
        List<OrderInfo> _orders = state.pendingOrdersList;
        if (_orders.isEmpty) return const SizedBox();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.smallSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton.iconOutlined(
                  label: "print_all".tr(),
                  icon: Icon(Icons.print, color: AppColors.primary),
                  height: AppDimensions.smallHeightButton,
                  onPressed: () {},
                ),
              ),
              AppSpacing.horizontal(AppDimensions.xSmallSpacing),
              Expanded(
                child: SecondaryButton.iconOutlined(
                  label: "find_shipper".tr(),
                  icon: Icon(
                    Icons.gps_fixed_outlined,
                    color: AppColors.secondary,
                  ),
                  height: AppDimensions.smallHeightButton,
                  onPressed: () {
                    _pkgsBloc.findShipper();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
