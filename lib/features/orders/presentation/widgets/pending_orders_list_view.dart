import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';
import 'package:oneship_shop/core/base/components/primary_empty_data.dart';
import 'package:oneship_shop/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_shop/core/base/components/secondary_button.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_shop/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_shop/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PendingOrdersListView extends StatefulWidget {
  const PendingOrdersListView({super.key});

  @override
  State<PendingOrdersListView> createState() => _PendingOrdersListViewState();
}

class _PendingOrdersListViewState extends State<PendingOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
  final PackagesBloc _pkgsBloc = getIt.get();

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _ordersBloc.fetchOrdersByStatus();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen:
              (previous, current) =>
                  previous.deleteOrderResource != current.deleteOrderResource,
          listener: _listenDeleteOrderState,
        ),
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen:
              (previous, current) =>
                  previous.pendingOrdersList != current.pendingOrdersList,
          listener: _listenOrdsListChanged,
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

                return PrimaryRefreshabelListView(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullUp: true,
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.smallSpacing,
                    horizontal: AppDimensions.smallSpacing,
                  ),
                  itemCount: _orders.length,
                  itemBuilder:
                      (context, index) => OrderInfoItem(
                        index: index + 1,
                        order: _orders[index],
                        onTap: _ordersBloc.openOrderDetail,
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

  void _onRemoved(OrderInfo order) {
    _ordersBloc.deleteOrder(order);
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

  void _onRefresh() {
    _ordersBloc.fetchOrdersByStatus();
  }

  void _onLoading() {
    if (!_ordersBloc.state.hasData) {
      _refreshController.loadNoData();
      return;
    }

    _ordersBloc.loadMoreOrders();
  }

  void _listenOrdsListChanged(BuildContext context, OrdersState state) {
    switch (state.orderListByStatusResource.state) {
      case Result.success:
        _refreshController
          ..refreshCompleted()
          ..loadComplete();
        break;
      case Result.error:
        _refreshController
          ..refreshFailed()
          ..loadFailed();
      default:
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
              // Expanded(
              //   child: PrimaryButton.iconOutlined(
              //     label: "print_all".tr(),
              //     icon: Icon(Icons.print, color: AppColors.primary),
              //     height: AppDimensions.smallHeightButton,
              //     onPressed: () {},
              //   ),
              // ),
              // AppSpacing.horizontal(AppDimensions.xSmallSpacing),
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
