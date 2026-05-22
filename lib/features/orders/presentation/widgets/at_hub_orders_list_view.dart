import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/response/orders_list_response.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/orders_state.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/order_info_item.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AtHubOrdersListView extends StatefulWidget {
  const AtHubOrdersListView({super.key});

  @override
  State<AtHubOrdersListView> createState() => _AtHubOrdersListViewState();
}

class _AtHubOrdersListViewState extends State<AtHubOrdersListView> {
  final OrdersBloc _ordersBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _ordersBloc.currentOrderStatus = OrderStatus.atHub;
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
                  previous.atHubOrdersList != current.atHubOrdersList,
          listener: _listenOrdsListChanged,
        ),
        BlocListener<OrdersBloc, OrdersState>(
          bloc: _ordersBloc,
          listenWhen:
              (previous, current) =>
                  previous.validateOrdAtHubResource !=
                  current.validateOrdAtHubResource,
          listener: _listenValidateOrdAtHubChanged,
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<OrdersBloc, OrdersState>(
              bloc: _ordersBloc,
              buildWhen:
                  (pre, cur) => pre.atHubOrdersList != cur.atHubOrdersList,
              builder: (context, state) {
                List<OrderInfo> _orders = state.atHubOrdersList;

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
                        onConfirmOrdAtHub: _onConfirmOrdAtHub,
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

  void _onConfirmOrdAtHub(OrderInfo order) {
    String hubId = _shopBloc.state.currentShop?.shopId ?? "";
    _ordersBloc.validateOrdAtHub(ordId: order.id!, hubId: hubId);
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

  void _listenValidateOrdAtHubChanged(BuildContext context, OrdersState state) {
    switch (state.validateOrdAtHubResource.state) {
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
          message: state.validateOrdAtHubResource.message,
        );
    }
  }
}
