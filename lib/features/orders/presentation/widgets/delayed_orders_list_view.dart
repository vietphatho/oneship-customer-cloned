import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_shop/core/base/base_import_components.dart';
import 'package:oneship_shop/core/base/components/primary_empty_data.dart';
import 'package:oneship_shop/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:oneship_shop/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_shop/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_shop/features/orders/presentation/widgets/order_info_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DelayedOrdersListView extends StatefulWidget {
  const DelayedOrdersListView({super.key});

  @override
  State<DelayedOrdersListView> createState() => _DelayedOrdersListViewState();
}

class _DelayedOrdersListViewState extends State<DelayedOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
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
                  previous.delayedOrdersList != current.delayedOrdersList,
          listener: _listenOrdsListChanged,
        ),
      ],
      child: BlocBuilder<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        buildWhen: (pre, cur) => pre.delayedOrdersList != cur.delayedOrdersList,
        builder: (context, state) {
          List<OrderInfo> orders = state.delayedOrdersList;

          if (orders.isEmpty) {
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
            itemCount: orders.length,
            itemBuilder:
                (context, index) => OrderInfoItem(
                  index: index + 1,
                  order: orders[index],
                  onTap: _ordersBloc.openOrderDetail,
                ),
            separatorBuilder:
                (context, index) =>
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
          );
        },
      ),
    );
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
